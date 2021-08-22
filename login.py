import pyrebase
# import DBConfig
import firebase_admin
from flask import Flask, redirect, url_for, render_template, request
from firebase_admin import credentials, firestore

firebaseConfig = {
    'apiKey' : "AIzaSyDFL1HQcIwmjQn1AKLFrITEMntMArIJFZA",
    'authDomain' : "bprotective-6c0a5.firebaseapp.com",
    'databaseURL' : "https://bprotective-6c0a5.firebaseio.com",
    'projectId' : "bprotective-6c0a5",
    'storageBucket' : "bprotective-6c0a5.appspot.com",
    'messagingSenderId' : "174786749703",
    'appId' : "1:174786749703:web:b51828accc19b80710d1a2",
    'measurementId' : "G-DRLP7SRMBP"
    }

firebase=pyrebase.initialize_app(firebaseConfig)
auth = firebase.auth()

# cred = credentials.ApplicationDefault()
# firebase_admin.initialize_app(cred, {
#   'projectId': "bprotective-6c0a5",
# })

# db = firestore.client

app = Flask (__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/signup", methods=['POST', 'GET'])
def signup(): 
    if request.method == 'POST':
        password = request.form['password']
        confirmPassword = request.form['confirmPassword']
        try:
            if password == confirmPassword:
                email = request.form['userName']
                password = request.form['password']
                role = request.form['userRole']
                new_user = auth.create_user_with_email_and_password(email, password)       
                # data = db.collection(u'Authority').document(u'')
                # data.set({
                #     u'Email': email,
                #     u'LocationLatitude': 0,
                #     u'LocationLongitude': 0,
                #     u'Role': role,
                #     u'Status': u'Online',
                #     u'UID': '',
                #     u'Username': email
                # })         
            return render_template("home.html")
        except:
            return render_template("signup.html")
    return render_template("signup.html")

@app.route("/login", methods=["POST", "GET"])
def login():
    if request.method == 'POST':
        email = request.form['userName']
        password = request.form['password']
        try:
            new_user = auth.sign_in_with_email_and_password(email, password)
            return render_template("home.html")
        except:
            return render_template("login.html")
    return render_template("login.html")

@app.route("/home", methods=['POST'])
def user():
    return render_template("home.html")

@app.route("/accounts")
def accounts():
    return render_template("accounts.html")

@app.route("/analyzeAlarms")
def analyzeAlarms():
    return render_template("analyzeAlarms.html")

@app.route("/logs")
def logs():
    return render_template("logs.html")

#TODO: TAKE OUT "debug=True" WHEN DEPOLYING FINAL PROJECT
if __name__ == "__main__":
    app.run(debug=True)