import API.DBConfig
from flask import *
import firebase_admin
from firebase_admin import credentials, firestore

app = Flask('__NormalUser__')

db = API.DBConfig.db

def get_all_normal_users():
    doc_ref = db.collection(u'NormalUser')
    for doc in doc_ref.stream():
        print(f'{doc.id} => {doc.to_dict()}')
    return doc_ref

def get_normal_user_by_id(id):
    doc_ref = db.collection(u'NormalUser').document(id)
    doc = doc_ref.get()
    print(f'{doc.id} => {doc.to_dict()}')
    return doc

def get_normal_user_data(user):
    doc_ref = db.collection(u'NormalUser').where(u'Username', u'==', user)
    for doc in doc_ref.stream():
        print((f'{doc.id} => {doc.to_dict()}'))
        print("Test message inside the get user data")
    return doc_ref

def ban_normal_user(id):
    db.collection(u'NormalUser').document(id).update({u'Banned' : True})
    return('UserID: ' + id + ' banned')

def unban_normal_user(id):
    db.collection(u'NormalUser').document(id).update({u'Banned' : False})
    return print('UserID: ' + id + ' unbanned')

def delete_normal_user(id):
    db.collection(u'NormalUser').document(id).delete()
    return print('UserID: ' + id + ' deleted')