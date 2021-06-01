import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import 'project.dart';
import 'user.dart';
import 'chat.dart';

User currentUser = User();
Project currentProject = Project(
    projectID: '',
    projectName: '',
    projectCreatedOn: '',
    projectRepoLink: '',
    projectAdmin: '',
    projectDescription: '');

Chat currentChat = Chat(chatID: '', chatName: '', members: '');

class SocketConnection {
  static const IPADDR = '192.168.1.36';
  static const PORT = 5050;
  SocketConnection._privateConstructor();

  static final SocketConnection instance =
      SocketConnection._privateConstructor();

  initializeSocket() async {
    Socket socket = await Socket.connect(IPADDR, PORT);
    print(socket.remoteAddress.address);
    // socket.listen((event) {
    //   print(String.fromCharCodes(event));
    //   socket.close();
    socket.close();
  }
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
