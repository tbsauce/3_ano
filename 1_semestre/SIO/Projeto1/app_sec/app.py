from flask import Flask, request, render_template, session, redirect, url_for
import sqlite3 as sql
import re
import os
from werkzeug.utils import safe_join
from cryptography.hazmat.primitives import hashes
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
import sys 
from random import randint

app = Flask(__name__)

app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'
#Rui
@app.errorhandler(404)
def page_not_found(e):
    # note that we set the 404 status explicitly
    return render_template('404.html'), 404
    
@app.route("/", methods=["POST", "GET"]) 
def index():
    if( request.method=="POST" ):
        db=sql.connect("webDB.db")
        code = request.form["code"]
        codigo= hash(code)
        result=db.execute("SELECT * FROM users WHERE code = ?", (codigo,))

        if result.fetchall() :
            db.close()
            if( "name" in session):
                return render_template("index.html", name=session["name"],codigo = 1)
            else:
                return render_template("index.html", codigo = 1)
        else:
            db.close()
            if( "name" in session):
                return render_template("index.html", name=session["name"],codigo = 2)
            else:
                return render_template("index.html", codigo = 2)

    else:
        if( "name" in session):
            return render_template("index.html", name=session["name"],codigo = 0)
        return render_template("index.html",codigo=0)

#Telmo
@app.route("/login", methods=["POST", "GET"]) 
def login(*args):

    if len(args) != 0:
        return render_template('login.html', error=args[0])
        
    db=sql.connect("webDB.db")
    if(request.method == "POST"):
        name = request.form["name"]
        password = request.form["Password"]

        password = hash(password)
        nome=hash(name)

        result=db.execute("SELECT * FROM users WHERE name = ? AND password = ?", (nome, password))

        if result.fetchall():
            db.close()
            session['name']=name
            return render_template('index.html',name=session["name"])
        else:
            db.close()
            return render_template('login.html', error=1)
    else:
        return render_template('login.html')


def hash(input):
    input=bytes(input, 'utf-8')
    digest = hashes.Hash(hashes.SHA256())
    digest.update(input)
    return  digest.finalize()

#Telmo
@app.route("/register" , methods=["POST", "GET"]) 
def register(*args):

    if len(args) != 0:
        return render_template('register.html', error=args[0])
        
    if(request.method == "POST"):
        nome = request.form["name"]
        emailAddress = request.form["EmailAddress"]
        password = request.form["Password"]
        db=sql.connect("webDB.db")

        password=hash(password)
        name=hash(nome)
        emailAddress=hash(emailAddress)

        result=db.execute("SELECT * FROM users WHERE name = ? OR email = ?", (name, emailAddress))
        data=result.fetchall()
        if(data!=[]):
            if(data[0][1]==name):
                print("Username already exists")
                return register(1)
            else:
                print("email")
                return register(2)
        else:
            session['name']=nome
            db.execute("INSERT INTO users (name, email, password) VALUES (?, ?, ?)", (name, emailAddress, password))
            db.commit()
            db.close()
        return profile()
    else:
        return render_template('register.html')
    
@app.route("/forgot-password", methods=["POST", "GET"])
def forgotPassword(*args):

    if len(args) != 0:
        return render_template('forgot-password.html', error=args[0])


    if(request.method == "POST"):
        name=request.form["name"]
        password=request.form["password"]
        newpassword=request.form["newpassword"]

        password=hash(password)
        name=hash(name)

        db=sql.connect("webDB.db")
        result=db.execute("SELECT * FROM users WHERE name = ? AND password = ?", (name,password))

        if result.fetchall() :
            print("User exists")
            newpassword=hash(newpassword)
            db.execute("UPDATE users SET password = ? WHERE name = ?", (newpassword, name))
            db.commit()
            db.close()
            return render_template("index.html",codigo=0)
        else:
            print("User does not exist")
            return forgotPassword(1)
    else:
        return render_template('forgot-password.html')

#Catarina
@app.route("/profile") 
def profile(*args):
    if len(args) != 0:
        return render_template('profile.html', error=args[0])
    else:
        return render_template('profile.html',name=session['name'])

    
#Catarina
@app.route("/comments", methods=["POST", "GET"])
def comentarios():
    db=sql.connect("webDB.db")
    if(request.method == "POST"):

        comment = request.form["comment"]
        db.execute("INSERT INTO comments (name,comment) VALUES (?,?)", (session["name"],comment,))
        result=db.execute("SELECT name,comment FROM comments;")
        data=result.fetchall()
        db.commit()
        db.close()

        return render_template('comments.html' , name=session['name'], comments=data)
    else:

        result=db.execute("SELECT name,comment FROM comments;")
        data=result.fetchall()
        db.close()
        if('name' in session):
            return render_template('comments.html' , name=session['name'], comments=data)
        else :
            return render_template('comments.html' , comments=data)

  
@app.route("/booking", methods=["POST", "GET"])
def bookings():
    db=sql.connect("webDB.db")
    if(request.method == "POST"):

        code=randint(1,100)
        print(code)
        codigo=hash(str(code))
        name=hash(session["name"])

        db.execute("update users set code = ? where name = ?", (codigo, name))
        db.commit()
        db.close()
        return render_template('booking.html' , name=session['name'], code=code)
    else:
        return render_template('booking.html' , name=session['name'])

@app.route("/logout") 
def logout():
    session.pop('name', None)
    return index()




if(__name__) =="__main__":
    app.run(debug=False)#Running the app in debug mode will show an interactive traceback and console in the browser when there is an error
    