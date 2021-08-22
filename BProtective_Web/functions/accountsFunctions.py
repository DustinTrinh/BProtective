import API.NormalUser

def getAllUsers():
    queryResult = ''
    for doc in API.NormalUser.get_all_normal_users().stream():
        queryResult = queryResult + (f'<div class="account"><div class="username">{doc.to_dict()["Username"]}</div>')
        queryResult = queryResult + (f"""<div class="log"><button onclick="location.href='/logs/{doc.to_dict()["Username"]}'">View Activity Log</button></div>""")
        queryResult = queryResult + (f"""<div class="buttons"><button>Add Authority</button>""")
        if doc.to_dict()["Banned"]:
            queryResult = queryResult + (f"""<button onclick="location.href='/accounts/unban/{doc.id}'">Unban User</button>""")
        else:
            queryResult = queryResult + (f"""<button onclick="location.href='/accounts/ban/{doc.id}'">Ban User</button>""")
        queryResult = queryResult + (f"""<button>Activate Account</button>""")
        queryResult = queryResult + (f"""<button onclick="location.href='/accounts/delete/{doc.id}'">Delete Account</button></div></div>\n""")
    return queryResult

def deleteUser(id):
    API.NormalUser.delete_normal_user(id)
    return getAllUsers()

def banUser(id):
    API.NormalUser.ban_normal_user(id)
    return getAllUsers()

def unbanUser(id):
    API.NormalUser.unban_normal_user(id)
    return getAllUsers()