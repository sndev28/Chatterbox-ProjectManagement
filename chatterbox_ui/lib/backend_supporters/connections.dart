import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/models/user.dart';
import '../models/project.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../models/chat.dart';

const host = '192.168.1.36';

final Uri userUri = Uri(scheme: 'http', host: host, path: '/user', port: 5000);

final Uri projectUri =
    Uri(scheme: 'http', host: host, path: '/projectdetails', port: 5000);

final Uri chatUri =
    Uri(scheme: 'http', host: host, path: '/chatdetails', port: 5000);

Future<int> newUserRegister(String username, String password) async {
  Response response = await post(
    userUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
      'updateCommand': 'newUserRegister',
    }),
  );
  return response.statusCode;
}

Future<List> retrieveUserFromID(String userID) async {
  Response response = await post(
    userUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'userID': userID,
      'updateCommand': 'retrieveUserFromID',
    }),
  );
  return [response.statusCode.toString(), response.body];
}

Future<List<String>> userLogin(String username, String password) async {
  Response response = await put(
    userUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );
  print('I AM HERE' + response.body);
  return [response.statusCode.toString(), response.body];
}

void userUpdate() async {
  Response response = await post(
    userUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'username': currentUser.username,
      'updateCommand': 'retrieveUserFromID',
    }),
  );

  if (response.statusCode == 200) currentUser.initializeFromJSON(response.body);
}

Future<List<String>> projectCreator(
    {String projectName = '',
    String projectDescription = '',
    String projectRepoLink = '',
    String projectAdmin = ''}) async {
  Response response = await put(
    projectUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'projectName': projectName,
      'projectDescription': projectDescription,
      'projectRepoLink': projectRepoLink,
      'projectAdmin': projectAdmin,
    }),
  );

  String projectID = jsonDecode(response.body)['projectID'];
  print(projectID);

  await patch(
    userUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'username': currentUser.username,
      'password': 'dummy',
      'projects': projectID,
    }),
  );

  return [response.statusCode.toString(), response.body];
}

void projectUpdate() async {
  Response response = await post(
    projectUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'projectID': currentProject.projectID,
    }),
  );

  if (response.statusCode == 200)
    currentProject.initializeFromJSON(response.body);
}

Future<Project> retrieveProjectFromID(String projectID) async {
  Response response = await post(
    projectUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'projectID': projectID,
    }),
  );

  print(response.body);

  Project retrievedProject = Project(
    projectID: '',
    projectName: '',
    projectCreatedOn: '',
    projectRepoLink: '',
    projectAdmin: '',
    projectDescription: '',
  );

  retrievedProject.initializeFromJSON(response.body);

  return retrievedProject;
}

Future<List<String>> chatCreator({String chatName = ''}) async {
  Response response = await put(
    chatUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'chatName': chatName,
      'members': currentUser.userID + ','
    }),
  );

  String chatID = jsonDecode(response.body)['chatID'];
  print(chatID);

  await patch(
    projectUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'projectID': currentProject.projectID,
      'projectChatList': chatID,
      'updateCommand': 'chat',
    }),
  );

  return [response.statusCode.toString(), response.body];
}

Future<Chat> retrieveChatFromID(String chatID) async {
  Response response = await post(
    chatUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'chatID': chatID,
    }),
  );

  print(response.body);

  Chat retrievedChat = Chat(chatID: '', chatName: '', members: '');

  retrievedChat.initializeFromJSON(response.body);

  return retrievedChat;
}

Future<void> memberDelete({String userID = '', String username = ''}) async {
  Response response;
  if (userID != '')
    response = await delete(projectUri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(<String, String>{
          'projectID': currentProject.projectID,
          'projectMembers': userID,
          'updateCommand': 'memberDelete_userID',
        }));
  else
    response = await delete(projectUri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(<String, String>{
          'projectID': currentProject.projectID,
          'projectMembers': username,
          'updateCommand': 'memberDelete_username',
        }));

  currentProject.initializeFromJSON(response.body);

  List currentProjectMembersIDsList = currentProject.projectMembers.split(',');
  currentProjectMembersList = [];
  for (var memberID in currentProjectMembersIDsList) {
    User tempUser = User();
    if (memberID != '' && memberID != ' ') {
      final response = await retrieveUserFromID(memberID);
      if (int.parse(response[0]) == 200) {
        tempUser.initializeFromJSON(response[1]);
        currentProjectMembersList.add(tempUser);
      }
    }
  }
}

Future<void> memberAdd({String userID = '', String username = ''}) async {
  Response response;
  if (userID != '')
    response = await patch(projectUri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(<String, String>{
          'projectID': currentProject.projectID,
          'projectMembers': userID,
          'updateCommand': 'members_userID',
        }));
  else
    response = await patch(projectUri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(<String, String>{
          'projectID': currentProject.projectID,
          'projectMembers': username,
          'updateCommand': 'members_username',
        }));

  currentProject.initializeFromJSON(response.body);

  List currentProjectMembersIDsList = currentProject.projectMembers.split(',');
  currentProjectMembersList = [];
  for (var memberID in currentProjectMembersIDsList) {
    User tempUser = User();
    if (memberID != '' && memberID != ' ') {
      final response = await retrieveUserFromID(memberID);
      if (int.parse(response[0]) == 200) {
        tempUser.initializeFromJSON(response[1]);
        currentProjectMembersList.add(tempUser);
      }
    }
  }
}

memberSearch(String username) async {
  Response response = await post(
    userUri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(
        <String, String>{'username': username, 'updateCommand': 'checkLike'}),
  );

  if (response.statusCode == 404) {
    searchMatches = [];
  } else {
    searchMatches = json.decode(response.body)['matches'].split(',');
    searchMatches.removeWhere((element) => element == '');
  }
}

Future<void> chatDelete({String chatID = ''}) async {
  Response response = await delete(projectUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(<String, String>{
        'projectID': currentProject.projectID,
        'projectChatList': chatID,
        'updateCommand': 'chatDelete',
      }));
  if (response.statusCode == 200) {
    currentProject.initializeFromJSON(response.body);

    final List<String> chatIDsFromDatabase =
        currentProject.projectChatList.split(',');

    for (var chatID in chatIDsFromDatabase) {
      if (chatID != '') {
        Chat newChat = await retrieveChatFromID(chatID);
        chatList.add(newChat);
      }
    }
  }
}
