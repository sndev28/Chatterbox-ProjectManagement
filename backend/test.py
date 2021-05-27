import requests
import json


BASE_URI = 'http://127.0.0.1:5000/'

data = {
    'projectID': 'PR_ID_ZJCBK8SIK2W1LAL',
    # 'projectName': 'test_1',
    # # 'projectCreatedOn': 'today',
    # # 'projectRepoLink': 'meh',
    # 'projectAdmin': 'MEEEE',
    # 'projectMembers': 'Me,Me,hououin kyouma'
}

response = requests.get(BASE_URI + 'projectdetails', data=data)

print(json.loads(response.text)['projectName'])