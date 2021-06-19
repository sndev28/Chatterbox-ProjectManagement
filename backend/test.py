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
    'username': 'ha',
    'updateCommand': 'checkLike'
}

response = requests.post(BASE_URI + 'user', data=data)

# meh = response.text.split(',')
# meh2 = [item + '}' for item in meh if item != '']

# print(meh)


print(json.loads(response.text)['matches'])