import 'dart:convert';
import 'dart:io';
import 'project.dart';
import 'user.dart';
import 'chat.dart';
import 'package:hive/hive.dart';
// ignore: unused_import
import 'package:hive_flutter/hive_flutter.dart';

User currentUser = User();
Project currentProject = Project(
    projectID: '',
    projectName: '',
    projectCreatedOn: '',
    projectRepoLink: '',
    projectAdmin: '',
    projectDescription: '');

List<String> currentChatMembersList = [];

Chat currentChat = Chat(chatID: '', chatName: '', members: '');

late Box openData;

class SocketConnection {
  static const IPADDR = '192.168.1.36';
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
        if (decodedMessage['message'] == 'START')
          releasingQueue = true;
        else if (decodedMessage['message'] == 'END') releasingQueue = false;
      } else if (openData.containsKey(decodedMessage['chatID']) == false) {
        List previousMessages = [];
        previousMessages = openData.get(decodedMessage['chatID']);
        previousMessages.add(message);
        openData.put(decodedMessage['chatID'], previousMessages);
      } else {
        if (decodedMessage['userID'] != currentUser.userID) {
          List previousMessages = [];
          if (openData.get(decodedMessage['chatID']) != null)
            previousMessages = openData.get(decodedMessage['chatID']);
          previousMessages.add(message);
          openData.put(decodedMessage['chatID'], previousMessages);
          if (releasingQueue)
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
// class ChatDatabase {
//   ChatDatabase._privateConstructor();
//   static final ChatDatabase instance = ChatDatabase._privateConstructor();

//   static Database _database;

//   Future<Database> get database async {
//     if (_database != null) return _database;
//     _database = await _initiate
//   }
// }
