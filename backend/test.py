import requests
import json


BASE_URI = 'http://192.168.1.36:5000/'

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
    'userID' : 'USER_ID_EBWCNPPVM00HSRR',
    'username': '_System:retrieveFromID',
    'password': 'dummy' 
}

response = requests.post(BASE_URI + 'user', data=data)

print(response.text)