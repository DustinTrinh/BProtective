import json
from firebase import Firebase
from google.cloud import firestore
from google.oauth2.credentials import Credentials

config = {
    "apiKey": "AIzaSyDFL1HQcIwmjQn1AKLFrITEMntMArIJFZA",
    "authDomain": "bprotective-6c0a5.firebaseapp.com",
    "databaseURL": "https://firestore.googleapis.com/v1/projects/bprotective-6c0a5/databases/",
    "projectId": "bprotective-6c0a5",
    "storageBucket": "bprotective-6c0a5.appspot.com",
}

firebase = Firebase(config)

response = firebase.auth().sign_in_with_email_and_password("jh@hotmail.com", "pastword")
cred = Credentials(response['idToken'], response['refreshToken'])
db = firestore.Client("bprotective-6c0a5", cred)