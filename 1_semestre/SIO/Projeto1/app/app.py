from flask import Flask, request, render_template, session, redirect, url_for
import sqlite3 as sql
import re
import os
from werkzeug.utils import safe_join
from random import randint
from flask import send_from_directory

app = Flask(__name__)

app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'
#Rui


@app.route("/", methods=["POST", "GET"]) 
def index():
    if( request.method=="POST" ):
        db=sql.connect("webDB.db")
        code = request.form["code"]
        result=db.execute("SELECT * FROM users WHERE code='"+str(code)+"';")

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
        result=db.execute("SELECT * FROM users WHERE name='"+name+"' AND password='"+password+"';")
        if result.fetchall():
            db.close()
            session['name']=name
            return render_template('index.html',name=session["name"])
        else:
            db.close()
            return render_template('login.html',error=1)
    else:
        return render_template('login.html',error=10)

#Telmo
@app.route("/register" , methods=["POST", "GET"]) 
def register(*args):

    if len(args) != 0:
        return render_template('register.html', error=args[0])
        
    if(request.method == "POST"):
        name = request.form["Name"]
        emailAddress = request.form["EmailAddress"]
        password = request.form["Password"]
        db=sql.connect("webDB.db")
        result=db.execute("SELECT * FROM users WHERE name='"+name+"' OR email='"+emailAddress+"';")
        data=result.fetchall()
        if(data!=[]):
            if(data[0][1]==name):
                print("Username already exists")
                return register(1)
            else:
                print("email")
                return register(2)
        else:
            session['name']=name
            db.execute("INSERT INTO users VALUES (NULL,'"+name+"','"+emailAddress+"','"+password+"', NULL);")
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
        db=sql.connect("webDB.db")
        result=db.execute("SELECT * FROM users WHERE name='"+name+"';")
        if result.fetchall() :
            db.execute("UPDATE users SET password='"+password+"' WHERE name='"+name+"';")
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
        db=sql.connect("webDB.db")
        result = db.execute("SELECT * FROM users WHERE name='"+session["name"]+"';")
        data=result.fetchall()
        db.close()
        return render_template('profile.html',name=session['name'],email=data[0][2],id=data[0][0])

    
#Catarina
@app.route("/comments", methods=["POST", "GET"])
def comentarios():
    db=sql.connect("webDB.db")
    if(request.method == "POST"):
        print(str(session['name']))
        print(str(request.form["comment"]))

        comment = request.form["comment"]
        db.execute("INSERT INTO comments VALUES (NULL,'"+session['name']+"','"+comment+"');")
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

        db.execute("update users set code='"+str(code)+"' where name='"+session["name"]+"';")
        db.commit()
        db.close()
        return render_template('booking.html' , name=session['name'], code=code)
    else:
        return render_template('booking.html' , name=session['name'])

@app.route("/logout") 
def logout():
    session.pop('name', None)
    return render_template('index.html')




if(__name__) =="__main__":
    app.run(debug=True)#Running the app in debug mode will show an interactive traceback and console in the browser when there is an error
    