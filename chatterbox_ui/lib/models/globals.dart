import 'dart:convert';
import 'dart:io';

import 'package:chatterbox_ui/backend_supporters/connections.dart';

import 'project.dart';
import 'user.dart';
import 'chat.dart';
import 'package:hive/hive.dart';
// ignore: unused_import
import 'package:hive_flutter/hive_flutter.dart';

const ADDR = '192.168.1.37';

const String SEPERATOR = '<sep>';

User currentUser = User();
Project currentProject = Project(
    projectID: '',
    projectName: '',
    projectCreatedOn: '',
    projectRepoLink: '',
    projectAdmin: '',
    projectDescription: '');

List<User> currentProjectMembersList = [];
List<User> currentChatMembersList = [];
Map<String, User> chatUsers = {};

Chat currentChat = Chat(chatID: '', chatName: '', members: '');

List searchMatches = [];
List<Chat> chatList = [];
List<String> tasksList = [];

late Box openData;

class SocketConnection {
  static const IPADDR = ADDR;
  static const PORT = 5050;
  SocketConnection._privateConstructor();
  static late Socket socket;
  static const SEPERATOR = '<sep>';

  static final SocketConnection instance =
      SocketConnection._privateConstructor();

  initializeSocket() async {
    socket = await Socket.connect(IPADDR, PORT);
    print(socket.remoteAddress.address);
    bool releasingQueue = false;

    socket.add(utf8.encode(
        messageEncoder('_SystemMessage', currentUser.userID, '_releaseQueue')));

    socket.listen((event) {
      String message = utf8.decode(event);
      Map decodedMessage = json.decode(message);

      if (decodedMessage['chatID'] == '_SystemMessage') {
        print('System message :' + decodedMessage['message']);
      } else if (decodedMessage['chatID'] == '_SystemMessage:_releaseQueue') {
        if (decodedMessage['message'] == 'START') {
          releasingQueue = true;
          sendMessage(messageEncoder(
              '_SystemMessage:_releaseQueue', 'system', '_releaseQueue'));
        } else if (decodedMessage['message'] == 'END') {
          releasingQueue = false;
          print(releasingQueue);
        }
      } else if (openData.containsKey(decodedMessage['chatID']) == false) {
        openData.put(decodedMessage['chatID'], message);
        if (releasingQueue) {
          sendMessage(messageEncoder(
              '_SystemMessage:_releaseQueue', 'system', '_releaseQueueNext'));
        }
      } else {
        List previousMessages = [];
        if (openData.get(decodedMessage['chatID']) != null)
          previousMessages = openData.get(decodedMessage['chatID']);
        previousMessages.add(message);
        openData.put(decodedMessage['chatID'], previousMessages);
        if (releasingQueue) {
          sendMessage(messageEncoder(
              '_SystemMessage:_releaseQueue', 'system', '_releaseQueueNext'));
        }
      }
    });
  }

  sendMessage(String encodedMessage) {
    socket.add(utf8.encode(encodedMessage));
  }

  closer() {
    socket.add(utf8.encode(messageEncoder('_SystemMessage:loggedOutUser',
        currentUser.userID, 'User logging out. Closing socket!')));
    socket.close();
  }
}

String messageEncoder(chatID, userID, message) {
  return '{"chatID":' +
      '"$chatID",' +
      '"userID":' +
      '"$userID",' +
      '"message":' +
      '"$message"' +
      '}';
}

var currentTheme;

// miscellaneous functions
chatInitializer() async {
  List currentChatMembersIDsList = currentChat.members.split(',');
  List currentProjectMembersIDsList = currentProject.projectMembers.split(',');
  currentChatMembersList = [];
  currentProjectMembersList = [];

  for (var memberID in currentChatMembersIDsList) {
    User tempUser = User();
    if (memberID != '' && memberID != ' ') {
      final response = await retrieveUserFromID(memberID);
      if (int.parse(response[0]) == 200) {
        tempUser.initializeFromJSON(response[1]);
        currentChatMembersList.add(tempUser);
      }
    }
  }
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
