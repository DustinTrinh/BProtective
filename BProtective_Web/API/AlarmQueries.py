import API.DBConfig
from flask import *
from google.cloud import firestore
app = Flask('__AlarmQueries__')

db = API.DBConfig.db

def getAllAlarms(lim):
    if (lim > 0):
        doc_ref = db.collection(u'Alarms').order_by("Date", direction = firestore.Query.DESCENDING).limit(lim)
    else:
        doc_ref = db.collection(u'Alarms').order_by("Date", direction = firestore.Query.DESCENDING)
    for doc in doc_ref.stream():
        print((f'{doc.id} => {doc.to_dict()}'))
    return doc_ref

def getAlarmsInRange(north, east, south, west, lim):
    if (lim > 0):
        doc_ref = db.collection(u'Alarms').order_by("Date", direction = firestore.Query.DESCENDING).limit(lim)
    else:
        doc_ref = db.collection(u'Alarms').order_by("Date", direction = firestore.Query.DESCENDING).where(u"latitude", u"<=", north).where(u"latitude", u">=", south).where(u"longitude", u"<=", east).where(u"longitude", u">=", west)
    for doc in doc_ref.stream():
        print((f'{doc.id} => {doc.to_dict()}'))
    return doc_ref

def getAlarmByID(id):
    doc_ref = db.collection(u'Alarms').document(id)
    doc = doc_ref.get()
    print(f'{doc.id} => {doc.to_dict()}')
    return doc

def getAlarmByUser(user):
    doc_ref = db.collection(u'Alarms').where(u'Username', u'==', user).order_by("Date", direction = firestore.Query.DESCENDING)
    for doc in doc_ref.stream():
        print((f'{doc.id} => {doc.to_dict()}'))
    return doc_ref

def createAlarm(id, date, lat, lon, status, username):
    doc_ref = db.collection(u'Alarms').document(id)
    doc_ref.set({
        u'Date': date,
        u'Latitude': lat,
        u'Longitude': lon,
        u'Status': status,
        u'Username': username
    })

def deleteAlarm(id):
    db.collection(u'Alarms').document(id).delete()