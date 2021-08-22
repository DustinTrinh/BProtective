import API.DBConfig
from flask import *
import firebase_admin
from firebase_admin import credentials, firestore

app = Flask('__SignIn__')

db = API.DBConfig.db

def get_all_authority_users():
    doc_ref = db.collection(u'Authority')
    for doc in doc_ref.stream():
        print(f'{doc.id} => {doc.to_dict()}')
    return doc_ref

def get_authority_user_by_id(id):
    doc_ref = db.collection(u'Authority').document(id)
    doc = doc_ref.get()
    print(f'{doc.id} => {doc.to_dict()}')
    return doc

def get_authority_user_data(user):
    doc_ref = db.collection(u'Authority').where(u'Username', u'==', user)
    for doc in doc_ref.stream():
        print((f'{doc.id} => {doc.to_dict()}'))
        print("Test message inside the get user data")
    return doc_ref
