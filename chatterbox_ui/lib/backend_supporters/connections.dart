import 'package:chatterbox_ui/models/globals.dart';
import '../models/project.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../models/chat.dart';

// const BASE_URI = 'http://127.0.0.1:5000/user';
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
    }),
  );
  return response.statusCode;
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

  return [response.statusCode.toString(), response.body];
}

void userUpdate() async {
  Response response = await post(
    userUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'username': currentUser.username,
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
      projectDescription: '');

  retrievedProject.initializeFromJSON(response.body);

  return retrievedProject;
}

Future<List<String>> chatCreator({String chatName = ''}) async {
  Response response = await put(
    chatUri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'chatName': chatName,
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
