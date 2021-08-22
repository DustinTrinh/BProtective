import API.ActivityLogQueries
from datetime import datetime

def getLogsByUser(user):
    queryResult = ''
    for doc in API.ActivityLogQueries.getActivityLogsByUser(user).stream():
        if "Emergency" in doc.to_dict()["Type"]:
            queryResult = queryResult + (f'<div class="log"><div class="type" style="color: red">{doc.to_dict()["Type"]}</div>')
        elif "Safe" in doc.to_dict()["Type"]:
            queryResult = queryResult + (f'<div class="log"><div class="type" style="color: limegreen">{doc.to_dict()["Type"]}</div>')
        else:
            queryResult = queryResult + (f'<div class="log"><div class="type">{doc.to_dict()["Type"]}</div>')
        queryResult = queryResult + (f'<div class="date">' + str(datetime.strptime(str(doc.to_dict()["Date"].replace(microsecond = 0)).split("+")[0], '%Y-%m-%d %H:%M:%S')) + '</div>')
        queryResult = queryResult + (f'<div class="lonlat"><span class="header">Longitude:</span> {doc.to_dict()["Longitude"]} <span class="header">Latitude:</span> {doc.to_dict()["Latitude"]}</div></div>\n')
    return queryResult