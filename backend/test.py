import requests
import json


BASE_URI = 'http://127.0.0.1:5000/'

# data = {
#     'projectID': 'PR_ID_ZJCBK8SIK2W1LAL',
    # 'projectName': 'test_1',
    # # 'projectCreatedOn': 'today',
    # # 'projectRepoLink': 'meh',
    # 'projectAdmin': 'MEEEE',
    # 'projectMembers': 'Me,Me,hououin kyouma'
# }

# data = {
#       'projectName': 'Dammit',
#       'projectDescription': 'dang it',
#       'projectRepoLink': 'chup',
#       'projectAdmin': 'map',
#     }

data = {
    'userID' : 'Damn yousdsd',
    'projects': ',aiufehbiaubhf'
}

response = requests.get(BASE_URI + 'userprojects', data=data)

print(response.text)