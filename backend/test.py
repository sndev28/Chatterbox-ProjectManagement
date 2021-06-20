import requests
import json


BASE_URI = 'http://192.168.1.37:5000/'

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
    'chatID': 'CH_ID_TKKHHY1DZILSG1P',
    'members': '2',
    'updateCommand': 'chatMemberDelete'
}

response = requests.delete(BASE_URI + 'chatdetails', data=data)

# meh = response.text.split(',')
# meh2 = [item + '}' for item in meh if item != '']

# print(meh)


print(json.loads(response.text)['members'])