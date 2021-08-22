import API.AlarmQueries
from datetime import datetime
import geopy
from geopy import distance

def getAlarms(limit):
    queryResult = ''
    queryResult = queryResult + (f'<div class="noAlarms"><span>Display the last <select id="noOfAlarms" onchange="this.options[this.selectedIndex].value && (window.location = this.options[this.selectedIndex].value);">')
    queryResult = queryResult + (f'<option value="/analyzeAlarms/limit=5"')
    if (int(limit) == 5):
        queryResult = queryResult + (f' selected')
    queryResult = queryResult + (f'>5</option>')
    queryResult = queryResult + (f'<option value="/analyzeAlarms/limit=25"')
    if (int(limit) == 25):
        queryResult = queryResult + (f' selected')
    queryResult = queryResult + (f'>25</option>')
    queryResult = queryResult + (f'<option value="/analyzeAlarms/limit=50"')
    if (int(limit) == 50):
        queryResult = queryResult + (f' selected')
    queryResult = queryResult + (f'>50</option>')
    queryResult = queryResult + (f'<option value="/analyzeAlarms/limit=100"')
    if (int(limit) >= 100):
        queryResult = queryResult + (f' selected')
    queryResult = queryResult + (f'>100</option>')
    queryResult = queryResult + (f'<option value="/analyzeAlarms/limit=0"')
    if (int(limit) <= 0):
        queryResult = queryResult + (f' selected')
    queryResult = queryResult + (f'>All</option>')
    queryResult = queryResult + (f'</select> Alarms</span></div>')
    for doc in API.AlarmQueries.getAllAlarms(int(limit)).stream():
        queryResult = queryResult + (f'<div id="{doc.id}" class="alarm" onclick="changeMap({doc.to_dict()["Latitude"]}, {doc.to_dict()["Longitude"]}, {doc.id})"><div class="username"><span class="header">User:</span> <span class="data">{doc.to_dict()["Username"]}</span></div>')
        queryResult = queryResult + (f'<div class="date"><span class="header">Date:</span> <span class="data">' + str(datetime.strptime(str(doc.to_dict()["Date"].replace(microsecond = 0)).split("+")[0], '%Y-%m-%d %H:%M:%S')) + '</span></div>')
        queryResult = queryResult + (f'<div class="lonlat"><span class="header">Longitude:</span> {doc.to_dict()["Longitude"]} <span class="header">Latitude:</span> {doc.to_dict()["Latitude"]}</div>')
        queryResult = queryResult + (f'<div class="status"><span class="header">Status:</span> <span class="data">{doc.to_dict()["Status"]}</data></div></div>\n')
    return queryResult

def getAlarmsInRangeOfSelected2(id, range, limit):
    queryResult = '<div class="noAlarms"><a href="/analyzeAlarms/limit=0">Return to All Alarms</a></div>'
    selected = API.AlarmQueries.getAlarmByID(id)
    center_point = [{'lat': selected.to_dict()["Latitude"], 'lng': selected.to_dict()["Longitude"]}]
    center_point_tuple = tuple(center_point[0].values())
    for doc in API.AlarmQueries.getAllAlarms(int(0)).stream():
        test_point = [{'lat': doc.to_dict()["Latitude"], 'lng': doc.to_dict()["Longitude"]}]
        radius = int(range) # in kilometer

        test_point_tuple = tuple(test_point[0].values()) # (-7.79457, 110.36563)

        dis = distance.distance(center_point_tuple, test_point_tuple).km

        if dis <= radius:
            queryResult = queryResult + (f'<div id="{doc.id}" class="alarm" onclick="changeMap({doc.to_dict()["Latitude"]}, {doc.to_dict()["Longitude"]}, {doc.id})"><div class="username"><span class="header">User:</span> <span class="data">{doc.to_dict()["Username"]}</span></div>')
            queryResult = queryResult + (f'<div class="date"><span class="header">Date:</span> <span class="data">' + str(datetime.strptime(str(doc.to_dict()["Date"].replace(microsecond = 0)).split("+")[0], '%Y-%m-%d %H:%M:%S')) + '</span></div>')
            queryResult = queryResult + (f'<div class="lonlat"><span class="header">Longitude:</span> {doc.to_dict()["Longitude"]} <span class="header">Latitude:</span> {doc.to_dict()["Latitude"]}</div>')
            queryResult = queryResult + (f'<div class="status"><span class="header">Status:</span> <span class="data">{doc.to_dict()["Status"]}</data></div></div>\n')

    return queryResult

def getAlarmsInRangeOfSelected(id, range, limit):
    selected = API.AlarmQueries.getAlarmByID(id)
    selectedCoord = geopy.Point(float(selected.to_dict()["Latitude"]), float(selected.to_dict()["Longitude"]))
    
    d = geopy.distance.geodesic(kilometers = int(range))
    latN = d.destination(point=selectedCoord, bearing=0).longitude
    lonE = d.destination(point=selectedCoord, bearing=90).latitude
    latS = d.destination(point=selectedCoord, bearing=180).longitude
    lonW = d.destination(point=selectedCoord, bearing=270).latitude
    
    for doc in API.AlarmQueries.getAlarmsInRange(latN, lonE, latS, lonW, int(limit)).stream():
        queryResult = queryResult + (f'<div id="{doc.id}" class="alarm" onclick="changeMap({doc.to_dict()["Latitude"]}, {doc.to_dict()["Longitude"]}, {doc.id})"><div class="username"><span class="header">User:</span> <span class="data">{doc.to_dict()["Username"]}</span></div>')
        queryResult = queryResult + (f'<div class="date"><span class="header">Date:</span> <span class="data">' + str(datetime.strptime(str(doc.to_dict()["Date"].replace(microsecond = 0)).split("+")[0], '%Y-%m-%d %H:%M:%S')) + '</span></div>')
        queryResult = queryResult + (f'<div class="lonlat"><span class="header">Longitude:</span> {doc.to_dict()["Longitude"]} <span class="header">Latitude:</span> {doc.to_dict()["Latitude"]}</div>')
        queryResult = queryResult + (f'<div class="status"><span class="header">Status:</span> <span class="data">{doc.to_dict()["Status"]}</data></div></div>\n')
    return queryResult