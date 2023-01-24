import socket
import base64
import cryptography
import PyKCS11
import threading
from cryptography.hazmat.primitives.asymmetric.padding import PKCS1v15
from cryptography import x509
from cryptography.hazmat.backends import default_backend as db
from cryptography.hazmat.backends import default_backend 
from cryptography.hazmat.primitives.hashes import SHA1, Hash
import json
import random
import pickle
import sys
import ast
import os
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.padding import PKCS7
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives.ciphers.modes import CBC

IP = socket.gethostbyname(socket.gethostname())
PORT = 5001
ADDR = (IP, PORT)
SIZE = 1024
FORMAT = "utf-8"
DISCONNECT_MSG = "!DISCONNECT"

#Everybody should validate the players cards, and players that provided an invalid card (repeated numbers, signature not valid, invalid size, etc…) should be immediately disqualified by the caller.
def main():
    # nick=input("Digite seu nick: ")
    nick="caller Joao"
    privKey , pubKey=makeAsimKey()
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    client.connect(ADDR)
    # print(f"[CONNECTED] CALLER connected to server at {IP}:{PORT}")
    #INNIT
    lib = '/usr/lib/x86_64-linux-gnu/pkcs11/opensc-pkcs11.so'

    pkcs11 = PyKCS11.PyKCS11Lib()
    pkcs11.load(lib)
    slot = pkcs11.getSlotList(tokenPresent=True)[0]

    session = pkcs11.openSession(slot)
    session.login('1111')
    
    cert=getCertificate(session) 
     
    sendJason(client, cert.public_bytes(serialization.Encoding.PEM)) 
    nonce=receiveJason(client)

    ass=signCertificate(nonce, session)

    sendJason(client, ass)

    if(receiveJason(client)!="Certificate Validated"):
        print("Certificate not validated")
        exit(1)

    
    pubkey_bytees=pubKey.public_bytes(serialization.Encoding.PEM, serialization.PublicFormat.SubjectPublicKeyInfo)
    signature=signCertificate(pubkey_bytees, session)
    sendJason(client,signature)
    sendJason(client,pubkey_bytees)

    PlayingArea_key=receiveJason(client)
    sign=assinar("NEW CALLER",privKey)
    sendSignature(client, sign,"NEW CALLER") 
    while True:
            msg=receiveSignature(client,PlayingArea_key) #11111111111111111111
            if msg == DISCONNECT_MSG:
                print(f"[CALLER] {msg}")
                exit(1)
            elif msg == "GAME STARTED":
                break
            else:
                print(f"[CALLER] {msg}")
                ass=assinar(nick,privKey)
                sendSignature(client,ass,nick)


    #START game
    print("START game")
    balls=(receiveSignature(client,PlayingArea_key).split(" "))[3] #"GAME STARTED DECK "+str(Board["Balls"])
    print("Balls: ", balls)

    #VALIDATE CARDS
    msg=receiveSignature(client,PlayingArea_key)    #CARDS[]
    cardsChecked = 0
    for player in msg:
        print("Player ", player[0], " has  ", player[1])
        if(validateCard(player[1], int (balls))):  
            cardsChecked = cardsChecked + 1 
        else:
            print("Player ", player[0], " has an invalid card")
            signature=assinar(player[0],privKey)
            sendSignature(client, signature ,player[0])    #send player to be removed
    
    #PARA SERVER SE CARD CHECK DER BEM
    if(cardsChecked == len(msg)):
        msg="CARDS VALID"
        signature=assinar(msg,privKey)
        sendSignature(client, signature ,msg)    #send player to be removed

    #Gen Deck
    deck=deck_gen(int(balls))
    print("1st suffled deck is : ", deck)
    deckEncriptado, key, iv = encrypt_deck(deck) #encrypt deck
    signature=assinar(deckEncriptado,privKey)
    sendSignature(client, signature ,deckEncriptado)    #send player to be removed


    #receive decks and validate
    msg = receiveSignature(client,PlayingArea_key)     #receive keys
    signature=assinar(key,privKey)
    sendSignature(client, signature ,key)    #send player to be removed
    signature=assinar(iv,privKey)
    sendSignature(client, signature ,iv)    #send player to be removed

    #Final Deck
    totalDeplayers = receiveSignature(client,PlayingArea_key)
    listOfKeys = receiveSignature(client,PlayingArea_key)
    deck_history= receiveSignature(client,PlayingArea_key)
    cards= receiveSignature(client,PlayingArea_key)
    DecDecks =[]
    for deck in deck_history:
        listOfKeystemp = listOfKeys[:deck[0]+1]
        listOfKeystemp.reverse()
        decktemp = deck[1]
        for id, key, iv in listOfKeystemp:
            # print("id: ", id)
            # print("key: ", deck[0])
            if(id == 0):
                deck = decrypt_deck(decktemp, key, iv)
                break
            decktemp = decrypt_deck(decktemp, key, iv)
        # print("deck: ", deck)
        newDeck = []
        for num in deck:
            num = num.decode()
            num = int(num)
            newDeck.append(num)
        ValidateDeck(newDeck, balls)
        DecDecks.append(newDeck)
    #enviar caso alguem tenha chetado no deck
    #falta determinar se tao todos bem com assinatura
    # print(cards)
    print("Winner " + str(DetWinner(cards, DecDecks[-1])))
    
    if( input("Do you want to see the log? (y/n)") == "y"):
        signature=assinar("yes",privKey)
        sendSignature(client,signature,"yes")
        log=receiveSignature(client,PlayingArea_key)
        print(log)
    
    print("Game Ended!")
    # while(1):
    #     pass
    exit(1)


def deck_gen(N):
    deck=[]
    for i in range(1, N+1):
        deck.append(i)
    shuffle_cards(deck)
    return deck

def card_gen(N):
    cards=[]
    while( len(cards) < N/4 ):
        card = random.randint(1, N)
        if card not in cards:
            cards.append(card)
    return cards

def shuffle_cards(cards):
    return random.shuffle(cards)

#temos de validar assinatura
def validateCard(card, N):
    seen = []
    if(len(card) != N/4):
        print("Invalid card size: ", card)
        return False
    for num in card:
        if num in seen:
            print("Invalid cards lenght: ", len(card))
            return False
        seen.append(num)
        if(num > N or num < 1):
            print("Invalid card number: ", num)
            return False
    return True
def ValidateDeck(deck, N):
    seen = []
    if(len(deck) != N):
        #print(len(deck) != N) true
       #print("Invalid deck size: ", deck)
        #print("N: ", N) #=16
        #print("size: ", len(deck))=16???
        return False
    for num in deck:
        if num in seen:
            print("Invalid deck repetead number: ", num)
            return False
        seen.append(num)
        if(num > N or num < 1):
            print("Invalid deck number: ", num)
            return False
    return True
def encrypt_deck(deck):
    #falta assinatura
    key = os.urandom(32)
    iv = os.urandom(16)
    newdeck=[]
    for num in deck:
        numEnc= encripta(num, key, iv)
        newdeck.append(numEnc)
    return newdeck, key, iv

#decripta cada uma das cartas
def decrypt_deck(deck, key, iv):
    #falta assinatura
    newdeck=[]
    for num in deck:
        numDec = decripta(num, key, iv)
        newdeck.append(numDec)
    return newdeck

def encripta(data, key ,iv):
    if(type(data) == int):
        data = str(data).encode()
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv))

    encryptor = cipher.encryptor()
    padder = PKCS7(128).padder()
    padded_data = padder.update(data) + padder.finalize()
    encrypted_data = encryptor.update(padded_data) + encryptor.finalize()

    return encrypted_data
    
def decripta(data, key, iv):
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv))
    decryptor = cipher.decryptor()
    decrypted_data = decryptor.update(data) + decryptor.finalize()
    unpadder = PKCS7(128).unpadder()
    decrypted_data = unpadder.update(decrypted_data) + unpadder.finalize()
    return decrypted_data


#gerar key simetrica
def makeSimKey(size):
    return 0
def Hash():
    return 
def AutenticateCard():
    return 0
#deck encryptado e embaralhado ver qual das cards ganha
def DetWinner(cards ,deck):
    winner = []
    #percorre players
    print("Final Deck Sufled", deck)
    # print("Cards", cards)
    for num in deck:
        #percorre cartas
        for card in cards:
            #se carta tiver o numero
            if num in card[1]:
                card[1].remove(num)
            if(len(card[1]) == 0):
                winner.append(card[0])
        if(winner != []):
            break
    return winner


def autentiate(pubkey,signature,text):
    text=pickle.dumps(text)
    try:
        pubkey.verify(
            signature,
            text,
            padding.PSS(
                mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.MAX_LENGTH
            ),
            hashes.SHA256()
        )
        return True
    except:
        return False
def assinar(text,private_key):
    text=pickle.dumps(text)
    signature = private_key.sign(
    text,
    padding.PSS(
        mgf=padding.MGF1(hashes.SHA256()),
        salt_length=padding.PSS.MAX_LENGTH
    ),
    hashes.SHA256()
    )  
    return signature
def receiveJason(conn):
    msg_length = conn.recv(4).decode(FORMAT)
    msg=conn.recv(int(msg_length))
    mgm=pickle.loads(msg)
    return mgm 
def sendJason(conn, msg):
    dump=pickle.dumps(msg)
    f=len(dump)
    size="%04d"%f
    conn.send(str(size).encode(FORMAT))
    conn.send(dump)
def receiveSocket(conn):
    msg_length = conn.recv(4).decode(FORMAT)
    msg=conn.recv(int(msg_length)).decode(FORMAT)
    return msg
def sendSocket(conn, msg):
    f=len(bytes(msg,"utf-8"))
    size="%04d"%f
    conn.send(str(size).encode(FORMAT))
    conn.send(msg.encode(FORMAT))
def receiveSignature(conn,pubkey):
    msg_length = conn.recv(4).decode(FORMAT)
    signature=conn.recv(int(msg_length))
    text=receiveJason(conn)
    try:
        autentiate(pubkey,signature,text)
    except:
        print("erro na assinatura")
        return False
    return text
def receiveKey(conn):
    msg_length = conn.recv(4)
    msg=conn.recv(int(msg_length))
    key = serialization.load_pem_public_key(
            msg,
            backend=default_backend()
        )
    return key
def sendSignature(conn,signature,text):
    f=len((signature))
    size="%04d"%f
    conn.send(str(size).encode(FORMAT))
    conn.send(signature)
    sendJason(conn,text)
    text = receiveJason(conn)
    if text == "Invalid Signature":
        exit(1)
def makeAsimKey():
    private_key = rsa.generate_private_key(
            public_exponent=65537,
            key_size=2048,
            backend=default_backend()
        )
    public_key = private_key.public_key()
    return(private_key,public_key)
def sendkey(conn, key):
    key = key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )
    f=len(key)
    size="%04d"%f
    conn.send(str(size).encode(FORMAT))
    conn.sendall(key)

def getCertificate(session):
    cert_obj = session.findObjects([
                    (PyKCS11.CKA_CLASS, PyKCS11.CKO_CERTIFICATE),
                    (PyKCS11.CKA_LABEL, 'CITIZEN AUTHENTICATION CERTIFICATE')
                    ])[0]

    cert_data = bytes(cert_obj.to_dict()['CKA_VALUE'])

    cert = x509.load_der_x509_certificate(cert_data, backend=db())
    return cert

def autentiateCertificate(cert,signature,text):
    pubkey = cert.public_key()
    try:
        md = hashes.Hash(hashes.SHA1(), backend=db())
        md.update(text)
        digest = md.finalize()


        pubkey.verify(
            signature,
            digest,
            PKCS1v15(),
            SHA1()
        )
        return True
    except:
        return False

def signCertificate(text,session):
    cert_obj = session.findObjects([
                  (PyKCS11.CKA_CLASS, PyKCS11.CKO_PRIVATE_KEY),
                  (PyKCS11.CKA_LABEL, 'CITIZEN AUTHENTICATION KEY')
                  ])[0]

    mechanism = PyKCS11.Mechanism(PyKCS11.CKM_SHA1_RSA_PKCS, None)

    signature = bytes(session.sign(cert_obj,text, mechanism))
    return signature

if __name__ == "__main__":
    main()