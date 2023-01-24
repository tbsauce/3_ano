import socket
import base64
import cryptography
import json
import threading
import random
import pickle
import base64
import uuid
import sys
import os
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.padding import PKCS7
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
import binascii
from cryptography.hazmat.primitives.asymmetric.padding import PKCS1v15
from cryptography import x509
from cryptography.hazmat.backends import default_backend as db
from cryptography.hazmat.primitives.hashes import SHA1, Hash
import socket
from cryptography import x509
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric.padding import PKCS1v15
import PyKCS11
import time

IP = socket.gethostbyname(socket.gethostname())
PORT = 5001
ADDR = (IP, PORT)
SIZE = 1024
FORMAT = "utf-8"
DISCONNECT_MSG = "!DISCONNECT"
Board={} 


# CENAS IMPORTANTES
# As mensagens sao transmitidas no formato: {tamanho da mensagem em 4 bytes}{mensagem}
# as keys antes de ser mandadas sao convertidas para base64
# db.json é  a bas de dados, nao ha necessidade de encriptar nada
class Player:
    id=0
    def __init__(self, nick="", pubKey=0):
        Player.id+=1
        self.id=Player.id
        self.nick = nick
        self.pubKey = pubKey
        self.card = None    #n usamos
        self.key = None
        self.iv = None
class Caller:
    def __init__(self, nick="", pubKey=0):
        self.id=0
        self.nick = nick
        self.pubKey = pubKey
        self.key = None
        self.iv = None
def add_to_log(text):
    text=str(text)
    key=Board["logKey"]
    iv=Board["logIv"]
    signature=encripta(text,key,iv)
    timestamp = time.time()
    if( len(Board["Log"]) >0):
        log_prev=Board["Log"][-1]
        prev_entry_hash = Hash(str(log_prev))
    else:
        prev_entry_hash = ""

    new_entry = (len(Board["Log"]) + 1, timestamp, prev_entry_hash, text,signature)

    Board["Log"].append(new_entry)

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
    private_key = session.findObjects([(PyKCS11.CKA_CLASS, PyKCS11.CKO_PRIVATE_KEY)])[0]

    mechanism = PyKCS11.Mechanism(PyKCS11.CKM_SHA1_RSA_PKCS, None)

    signature = bytes(session.sign(private_key, text, mechanism))
    return signature
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
    if not autentiate(pubkey,signature,text):
        print("erro na assinatura")
        sendJason(conn,"Invalid Signature")
        return "Invalid Signature"
    sendJason(conn,"Signature")
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
    f=len(signature)
    size="%04d"%f
    conn.send(str(size).encode(FORMAT))
    conn.send(signature)
    sendJason(conn,text)
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
def denyplayer(conn, addr):
    
    print(f"[CONNECTION DENIED] {addr}")
    msg = DISCONNECT_MSG
    sendSocket(conn, msg)
    conn.close()
#sequencia inicial de esperar players
def waitPlayers(total): 
    if(Board["TotalPlayers"] == total):
        return False
    return True
#sequencia inicial de esperar Callers
def waitCaller():
    if(0 in Board):
        return False
    return True
def waitCards(conn,id):
    if(id!=0):
        card=receiveSignature(conn,Board[id].pubKey) #recebe a assinatura do deck)     #recebe o deck encriptado pelo caller 1 deck
        if(card=="Invalid Signature"):
            disqualify(id)
            return "Invalid Signature"
        Board["TotalCards"].append((id,card))
        add_to_log("Player "+str(id)+" sent his deck"+str(card))
    while len( Board["TotalCards"])!=Board["TotalPlayers"]:
        pass
    return Board["TotalCards"]
def disqualify(id):
    if(id != 0):
        Board["TotalPlayers"]-=1
    Board["Cheaters"].append(id)
#encripta cada uma das cartas

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
    decrypted_data = decrypted_data.decode()
    decrypted_data = int(decrypted_data)
    return decrypted_data

def AutenticateCard():
    return 0
def Hash(insert):
    insert = bytes(insert, 'utf-8')
    hash = hashes.Hash(hashes.SHA256())
    hash.update(insert)
    return hash.finalize()
#gerar key simetrica com ChaCha20
def makeSimKey(size):
    if size not in [1024, 2048, 4096]:
        print("Invalid key size must be 1024 or 2048 or 4096!")
        sys.exit(1)
    simkey = PBKDF2HMAC (
        algoritmo = hashes.SHA256(),
        size = 32,
        salt = os.urandom(16),
        iterations= 10000
    )
    password = "GerarKeySimétrica"
    key = simkey.derive(password.encode())
    
    algoritmo = "ChaCha20"
    key = key[:64]
    
    return key
def handle_caller(conn, addr, privkeyA, pubkey_cliente):
    
    pessoa = Caller()


    sign=assinar("Waiting for Players",privkeyA)
    sendSignature(conn, sign,"Waiting for Players")

    CallerName=receiveSignature(conn,pubkey_cliente) #Pubkey
    pessoa.nick=CallerName
    pessoa.pubKey=pubkey_cliente
    Board[pessoa.id] = pessoa
    add_to_log("Caller added with id "+str(pessoa.id)+"and nick"+str(CallerName))
    print(f"[CALLER] Id:{pessoa.id} Nick:{pessoa.nick} ") # pubKey:{pessoa.pubKey}



    while(Board["gameState"] != "STARTED"):
        pass

    ass=assinar("GAME STARTED",privkeyA)
    add_to_log("Game started")
    sendSignature(conn, ass,"GAME STARTED")
    startGameCaller( conn, 0, privkeyA,pubkey_cliente)
    endGame(conn,privkeyA)
def handle_client(conn, addr, privkeyA, pubkey_cliente):

    pessoa = Player()

    sign=assinar("Waiting for Players",privkeyA)
    sendSignature(conn, sign,"Waiting for Players")

    CallerName=receiveSignature(conn,pubkey_cliente) #Pubkey
    pessoa.nick=CallerName
    pessoa.pubKey=pubkey_cliente
    Board[pessoa.id] = pessoa
    add_to_log("Player added with id " +str(pessoa.id)+" and nick "+str(CallerName))

    Board["TotalPlayers"] += 1
    print(f"[PLAYER] Id:{pessoa.id} Nick:{pessoa.nick}") #pubKey:{pessoa.pubKey}
        

    while(Board["gameState"] != "STARTED"):
        pass

    ass=assinar("GAME STARTED",privkeyA)
    sendSignature(conn, ass,"GAME STARTED")
    startGame( conn, pessoa.id, privkeyA)
    endGame(conn,privkeyA)
##Secalhar podemos tirar mas deixa por agr
def startGameCaller(conn, id, privKey,callerKey):

    mensagem="GAME STARTED DECK "+str(Board["Balls"])
    signature=assinar(mensagem,privKey)                 #"GAME STARTED DECK 1"
    sendSignature (conn,signature,mensagem)

    cards=waitCards(conn,id)
    signature=assinar(cards,privKey)                    #CARDS[]
    sendSignature(conn, signature,cards)
    
    msgm=receiveSignature(conn,callerKey) #recebe a assinatura do deck
    if(msgm!="CARDS VALID"):
        disqualify(msgm) #msgm = player id
        add_to_log("Player "+str(msgm)+" disqualified")
    else:
        disqualify(0)   #ninguem desqualificado
        
    while (id!=len(Board["DeckHistory"] )): # Espera que seja a vez do jogador este e o 1 por ser caller
        pass

    deckCaller=receiveSignature(conn,callerKey) #recebe a assinatura do deck)     #recebe o deck encriptado pelo caller 1 deck
    add_to_log("Recieved deck from caller the deck "+str(deckCaller))
    Board["DeckHistory"].append((id, deckCaller))

    while(len(Board["DeckHistory"])!=Board["TotalPlayers"]+1):  #espera que todos os jogadores tenham dado shuffle
        pass

    signature = assinar("WAITING KEYS",privKey)     #espera que o caller receba as keys Symetricas
    sendSignature(conn, signature,"WAITING KEYS") #espera que o caller receba as keys Symetricas
    Board[id].key= receiveSignature(conn,callerKey) #espera que o caller receba as keys Symetricas
    Board[id].iv= receiveSignature(conn,callerKey) #espera que o caller receba os IVs
    add_to_log("Recieved keys from caller the key "+str(Board[id].key)+" and the iv "+str(Board[id].iv))
    listKeys=[]
    ready = False
    while(not ready): #espera que o caller receba as keys Symetricas
        listKeys=[]
        ready = True
        for ids in range(int(Board["TotalPlayers"]+1)):
            if Board[ids].key == None or Board[ids].iv == None or Board[id].key == "Invalid Signature" or Board[id].iv == "Invalid Signature":
                ready = False
                break
            listKeys.append((ids, Board[ids].key, Board[ids].iv))

    #envia a lista de decks encriptados
    signature = assinar(Board["TotalPlayers"]+1,privKey)                   
    sendSignature(conn, signature,Board["TotalPlayers"]+1)
    
    
    # print(listKeys)
    
    #envia a lista de keys
    signature=assinar(listKeys,privKey)                   
    sendSignature(conn, signature,listKeys)
    #envia a lista de decks encriptados
    signature=assinar(Board["DeckHistory"],privKey)                   
    sendSignature(conn, signature,Board["DeckHistory"])
    signature=assinar(Board["TotalCards"],privKey)                   
    sendSignature(conn, signature,Board["TotalCards"])
    
    
    msgm=receiveSignature(conn,callerKey) #espera que o caller receba as keys Symetricas
    if(msgm=="yes"):
        ass=assinar(Board["Log"],privKey)
        sendSignature(conn,ass,Board["Log"])
    

def startGame(conn, id, privKey):
    mensagem="GAME STARTED DECK "+str(Board["Balls"])
    signature=assinar(mensagem,privKey)                 #"GAME STARTED DECK 1"
    sendSignature (conn,signature,mensagem)
   
    cards=waitCards(conn,id)    #espera todos criarem as cartas e cria a sua
    if(cards=="Invalid Signature"):
        return None
    signature=assinar(cards,privKey)                    #CARDS[]
    sendSignature(conn, signature,cards)


    while Board["Cheaters"] == []:
        pass

    if(id in Board["Cheaters"]):
        signature=assinar("CHEATER",privKey)                
        sendSignature(conn, signature,"CHEATER")
        return None
    signature=assinar("NOT CHEATER",privKey)           
    sendSignature(conn, signature,"NOT CHEATER")
        
    while (id!=len(Board["DeckHistory"]) ): # Espera que seja a vez do jogador dar shuffle
        pass

    # Envia o deck encriptado por todos os jogadores
    signature=assinar(Board["DeckHistory"][id-1][1],privKey)           
    sendSignature(conn, signature,Board["DeckHistory"][id-1][1])
    
    msgm=receiveSignature(conn,Board[id].pubKey) #recebe a assinatura do deck
    add_to_log("Recieved deck from player "+str(id)+" the deck "+str(msgm))
    # print(msgm)
    if(msgm == "Invalid Signature"):
        disqualify(id)
        add_to_log("Player "+str(id)+" disqualified")
        return None
    Board["DeckHistory"].append((id, msgm)) #mete para a lista de decks encriptados
    while(len(Board["DeckHistory"])!=Board["TotalPlayers"]+1):  #espera que todos os jogadores tenham dado shuffle
        pass

    signature = assinar("WAITING KEYS",privKey)                    #espera que o caller receba as keys Symetricas
    sendSignature(conn, signature,"WAITING KEYS") #espera que o caller receba as keys Symetricas
    Board[id].key= receiveSignature(conn,Board[id].pubKey) #espera que o caller receba as keys Symetricas
    Board[id].iv= receiveSignature(conn,Board[id].pubKey) #espera que o caller receba os IVs
    add_to_log("Recieved keys from player "+str(id)+" the key "+str(Board[id].key)+" and the iv "+str(Board[id].iv))
    if(Board[id].key == "Invalid Signature" or Board[id].iv == "Invalid Signature"):
        disqualify(id)
        add_to_log("Player "+str(id)+" disqualified")
        return None


    listKeys=[]
    ready = False
    while(not ready): #espera que o caller receba as keys Symetricas
        listKeys=[]
        ready = True
        for ids in range(int(Board["TotalPlayers"]+1)):
            if Board[ids].key == None or Board[ids].iv == None or Board[ids].key == "Invalid Signature" or Board[ids].iv == "Invalid Signature":
                ready = False
                break
            listKeys.append((ids, Board[ids].key, Board[ids].iv))
            

    signature = assinar(Board["TotalPlayers"]+1,privKey)                   
    sendSignature(conn, signature,Board["TotalPlayers"]+1)
    
    

    # print(listKeys)
    
    #envia a lista de keys
    signature=assinar(listKeys,privKey)                   
    sendSignature(conn, signature,listKeys)
    #envia a lista de decks encriptados
    signature=assinar(Board["DeckHistory"],privKey)                   
    sendSignature(conn, signature,Board["DeckHistory"])
    signature=assinar(Board["TotalCards"],privKey)                   
    sendSignature(conn, signature,Board["TotalCards"])
    
    msgm=receiveSignature(conn,Board[id].pubKey)
    if(msgm=="yes"):

        ass=assinar(Board["Log"],privKey)
        sendSignature(conn,ass,Board["Log"])

def endGame(conn,privKey):
    Board["gameState"] = "ENDED"
def main():
    pubKey=None
    privkeyA ,pubkeyA =makeAsimKey()
    print("[STARTING] Server is starting...")
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind(ADDR)
    server.listen()
    server.settimeout(1)
    print(f"[LISTENING] Server is listening on {IP}:{PORT}")
    Board["gameState"]="init"
    Board["DeckHistory"]=[]
    Board["Cheaters"]=[]
    Board["logKey"]=os.urandom(16)
    Board["logIv"]=os.urandom(16)
    Board["Log"]=[]

    #Board["TotalPlayers"]=int(input("Number of Players for Game: "))
    Players=1
    Board["TotalPlayers"]=0
    #Board["Balls"]=int(input("Number of Balls for Game: "))
    Board["Balls"]=16
    Board["TotalCards"]=[]

    #init board
    while True:
        if(not waitPlayers(Players) and not waitCaller()):
            print("Game Started")
            Board["gameState"]="STARTED"
            break
        
        try:
            conn, addr = server.accept()

            cert=receiveJason(conn)

            cert=x509.load_pem_x509_certificate(cert, default_backend())
            
            nonce=os.urandom(16)
            sendJason(conn,nonce)

            signature=receiveJason(conn)
            if autentiateCertificate(cert,signature,nonce):
                print("Certificate Validated")
                sendJason(conn,"Certificate Validated")

                signature=receiveJason(conn)
                key=receiveJason(conn)
                if autentiateCertificate(cert,signature,key):
                    print("Key Validated")
                else:
                    print("key invalid ")
                    conn.close()

                pubkey=serialization.load_pem_public_key(key, default_backend())
            else:
                print("Certificate Invalid")
                sendJason(conn,"Certificate Invalid")
                conn.close()


            pubkeyA_bytes=pubkeyA.public_bytes(serialization.Encoding.PEM, serialization.PublicFormat.SubjectPublicKeyInfo)
            sendJason(conn,pubkeyA_bytes)

            msg = receiveSignature(conn, pubkey)

            if(waitCaller() and msg == "NEW CALLER"):
                thread = threading.Thread(target=handle_caller, args=(conn, addr, privkeyA, pubkey))
                thread.start()
            elif(waitPlayers(Players) and msg == "NEW PLAYER"):
                thread = threading.Thread(target=handle_client, args=(conn, addr, privkeyA, pubkey))
                thread.start()
            else:
                thread = threading.Thread(target=denyplayer, args=(conn, addr))
                thread.start()
                thread.join()
        except socket.timeout:
            pass

    while(Board["gameState"] != "ENDED"):
        pass

    print("Game Ended!")
    thread.join()
    conn.close()
    server.close()
    exit(1)
if __name__ == "__main__":
    main()  


