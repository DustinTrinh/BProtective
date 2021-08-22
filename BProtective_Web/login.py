import pyrebase
import API.DBConfig
import API.SignIn
import API.AlarmQueries
import API.NormalUser
import API.ActivityLogQueries
import firebase_admin

import functions.accountsFunctions
import functions.alarmsFunctions
import functions.logsFunctions

from datetime import datetime
from flask import Flask, redirect, url_for, render_template, request
from firebase_admin import credentials, firestore

firebase=pyrebase.initialize_app(API.DBConfig.config)
auth = firebase.auth()

db = API.DBConfig.db

app = Flask (__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/signup", methods=['POST', 'GET'])
def signup(): 
    if (request.method == 'POST'):
        password = request.form['password']
        confirmPassword = request.form['confirmPassword']
        try:
            if password == confirmPassword:
                email = request.form['userName']
                password = request.form['password']
                role = request.form['userRole']
                auth.create_user_with_email_and_password(email, password)       
                if role == "Authority":
                    API.SignIn.create_user_authority_user(email, role)
                elif role == "Normal":
                    API.SignIn.create_user_normal_user(email, role)
            return render_template("home.html")
        except:
            return render_template("signup.html")
    return render_template("signup.html")

@app.route("/login", methods=['POST', 'GET'])
def login():
    if (request.method == 'POST'):
        email = request.form['name']
        password = request.form['passwd']        
        try:
            auth.sign_in_with_email_and_password(email, password)
            return render_template("home.html")
        except:
            return render_template("login.html")
    return render_template("login.html")

# Reseting password by user
@app.route("/passwordReset", methods=['POST', 'GET'])
def passwordReset():
    if (request.method == 'POST'):
        email = request.form['name']
        # pw1 = request.form['passwd1']
        # pw2 = request.form['passwd2']
        # try:
        auth.send_password_reset_email(email)
            # if(pw1 == pw2):
            #     if(query_auth):
            #         db.collection(u'Authority').document(id).update({u'Password' : pw1})
            #     if(query_norm):
            #         db.collection(u'NormalUser').document(id).update({u'Password' : pw1})
        # except:
        #     return render_template("passwordReset.html")
    return render_template("passwordReset.html")

#Homepage when user logs in
@app.route("/home", methods=["POST", "GET"])
def user():
    return render_template("home.html")

#Accounts page routes
@app.route("/accounts")
def accounts():
    return render_template("accounts.html", AccountList = functions.accountsFunctions.getAllUsers())

@app.route("/accounts/delete/<id>")
def deleteAccount(id):
    functions.accountsFunctions.deleteUser(id)
    return accounts()

@app.route("/accounts/ban/<id>")
def banAccount(id):
    functions.accountsFunctions.banUser(id)
    return accounts()

@app.route("/accounts/unban/<id>")
def unbanAccount(id):
    functions.accountsFunctions.unbanUser(id)
    return accounts()

#Activity Logs Page Routes
@app.route("/logs/<user>")
def getLogsByUser(user):
    return render_template('logs.html', ActivityLogsList = functions.logsFunctions.getLogsByUser(user))

#Alarms Page routes
@app.route("/analyzeAlarms/limit=<limit>")
def analyzeAlarms(limit):
    return render_template('analyzeAlarms.html', AlarmList = functions.alarmsFunctions.getAlarms(limit))

@app.route("/analyzeAlarms/id=<id>&range=<range>&limit=<limit>")
def getAlarmsInRange(id, range, limit):
    return render_template('analyzeAlarms.html', AlarmList = functions.alarmsFunctions.getAlarmsInRangeOfSelected2(id, range, limit)) 

#TODO: TAKE OUT "debug=True" WHEN DEPOLYING FINAL PROJECT
if __name__ == "__main__":
    app.run(debug=True)