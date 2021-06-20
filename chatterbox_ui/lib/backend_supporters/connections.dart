import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/models/user.dart';
import '../models/project.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../models/chat.dart';

const host = ADDR;

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
      'userID': currentUser.userID,
      'updateCommand': 'retrieveUserFromID',
    }),
  );
  print(response.body + "THIS IS THE RESPONSE");

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
    chatList = [];
    for (var chatID in chatIDsFromDatabase) {
      if (chatID != '') {
        Chat newChat = await retrieveChatFromID(chatID);
        chatList.add(newChat);
      }
    }
  }
}

Future<void> projectValueUpdater(
    {String updateDetail = '', String updationValue = ''}) async {
  Response response = await patch(projectUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(<String, String>{
        'projectID': currentProject.projectID,
        updateDetail: updationValue,
        'updateCommand': updateDetail,
      }));

  if (response.statusCode == 200) {
    currentProject.initializeFromJSON(response.body);
  }
}

Future<bool> usernameUpdate({String newUsername = ''}) async {
  Response response = await post(userUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(<String, String>{
        'userID': currentUser.userID,
        'username': newUsername,
        'updateCommand': 'usernameUpdate',
      }));

  if (response.statusCode == 409) {
    return false;
  } else {
    currentUser.initializeFromJSON(response.body);
    return true;
  }
}

Future<void> passwordUpdate({String newPassword = ''}) async {
  Response response = await post(userUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(<String, String>{
        'userID': currentUser.userID,
        'password': newPassword,
        'updateCommand': 'passwordUpdate',
      }));

  if (response.statusCode != 200) {
    print(response.reasonPhrase);
  }
}

Future<void> tasksAdd(String task) async {
  Response response = await patch(
    projectUri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(<String, String>{
      'projectID': currentProject.projectID,
      'updateCommand': 'tasks',
      'projectTasks': task,
    }),
  );

  if (response.statusCode == 200) {
    currentProject.initializeFromJSON(response.body);
    tasksList = currentProject.projectTasks.split(SEPERATOR);
    tasksList.remove('');
  }
}

Future<void> tasksDelete(String task) async {
  Response response = await delete(
    projectUri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(<String, String>{
      'projectID': currentProject.projectID,
      'updateCommand': 'tasksDelete',
      'projectTasks': task,
    }),
  );
  if (response.statusCode == 200) {
    currentProject.initializeFromJSON(response.body);
    tasksList = currentProject.projectTasks.split(SEPERATOR);
    tasksList.remove('');
  }
}

Future<void> deleteAllTasks() async {
  Response response = await delete(projectUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(<String, String>{
        'projectID': currentProject.projectID,
        'updateCommand': 'deleteAllTasks',
      }));

  if (response.statusCode == 200) {
    currentProject.initializeFromJSON(response.body);
    tasksList = currentProject.projectTasks.split(SEPERATOR);
    tasksList = [];
  }
}

Future<void> chatMemberAdd({String username = ''}) async {
  Response response = await patch(
    chatUri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(<String, String>{
      'chatID': currentChat.chatID,
      'members': username,
      'updateCommand': 'chatMemberAdd',
    }),
  );

  if (response.statusCode == 200) {
    currentChat.initializeFromJSON(response.body);
    await chatInitializer();
  }
}

Future<void> chatMemberDelete({String username = ''}) async {
  Response response = await delete(
    chatUri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(<String, String>{
      'chatID': currentChat.chatID,
      'members': username,
      'updateCommand': 'chatMemberDelete',
    }),
  );

  if (response.statusCode == 200) {
    currentChat.initializeFromJSON(response.body);
    await chatInitializer();
  }
}
