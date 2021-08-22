import API.DBConfig
from flask import *
from google.cloud import firestore
app = Flask('__ActivityLogQueries__')

db = API.DBConfig.db

def getAllActivityLogs():
    doc_ref = db.collection(u'ActivityLogs').order_by("Date", direction = firestore.Query.DESCENDING)
    for doc in doc_ref.stream():
        print((f'{doc.id} => {doc.to_dict()}'))
    return doc_ref

def getActivityLogByID(id):
    doc_ref = db.collection(u'ActivityLogs').document(id)
    doc = doc_ref.get()
    print(f'{doc.id} => {doc.to_dict()}')
    return doc

def getActivityLogsByUser(user):
    queryResult = ''
    doc_ref = db.collection(u'ActivityLogs').where(u'Username', u'==', user).order_by("Date", direction = firestore.Query.DESCENDING)
    for doc in doc_ref.stream():
        queryResult = queryResult + (f'{doc.id} => {doc.to_dict()},\n')
    return doc_ref

def createActivityLog(id, date, lat, lon, type, username):
    doc_ref = db.collection(u'ActivityLogs').document(id)
    doc_ref.set({
        u'Date': date,
        u'Latitude': lat,
        u'Longitude': lon,
        u'Type': type,
        u'Username': username
    })

def deleteActivityLog(id):
    db.collection(u'ActivityLogs').document(id).delete()