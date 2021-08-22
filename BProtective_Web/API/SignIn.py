import API.DBConfig
from flask import *
import firebase_admin
from firebase_admin import credentials, firestore

app = Flask('__SignIn__')

db = API.DBConfig.db

def create_user_authority_user(email, role):   
    role = request.form['userRole']
    if role == "Authority":
        data = db.collection(u'Authority').document()
        data.set({
            u'Email': email,
            u'LocationLatitude': 0,
            u'LocationLongitude': 0,
            u'Role': role,
            u'Status': u'Online',
            u'Username': email,
            u'Banned' : False
        })      

def create_user_normal_user(email, role):   
    role = request.form['userRole']
    if role == "Normal":
        data1 = db.collection(u'NormalUser').document()
        data1.set({
            u'Email': email,
            u'LocationLatitude': 0,
            u'LocationLongitude': 0,
            u'Role': role,
            u'Status': u'Online',
            u'Username': email,
            u'Banned' : False
        }) 
