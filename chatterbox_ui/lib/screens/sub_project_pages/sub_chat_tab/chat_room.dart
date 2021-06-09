import 'dart:convert';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chatterbox_ui/models/chat.dart';
import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/styles/colors.dart';
import 'package:chatterbox_ui/styles/font_styles.dart';
import 'package:flutter/material.dart';
import '../../../navigations.dart';
// ignore: unused_import
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({Key? key}) : super(key: key);

  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.red[400],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                currentChat = Chat();
              },
              icon: Icon(Icons.arrow_back_ios)),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.settings_outlined, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, chatSettings);
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 10.0,
                    spreadRadius: 3.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Center(
                  child: Text(currentChat.chatName, style: HomeChatStyle)),
            ),
            Expanded(
              child: Container(
                child: ValueListenableBuilder(
                  valueListenable: openData.listenable(),
                  builder: (context, Box openData, _) {
                    List<String> listOfMessages = <String>[];
                    if (openData.get(currentChat.chatID) == null) {
                      List<String> emptyList = [];
                      openData.put(currentChat.chatID, emptyList);
                    } else
                      listOfMessages = openData.get(currentChat.chatID);
                    return ListView.builder(
                      itemCount: listOfMessages.length,
                      itemBuilder: (context, index) {
                        Map message = jsonDecode(listOfMessages[index]);
                        return BubbleNormal(
                          text: message['message'],
                          isSender: message['userID'] == currentUser.userID
                              ? true
                              : false,
                          color: message['userID'] == currentUser.userID
                              ? Color(0xFFFCE4EC)
                              : Colors.white,
                          tail:
                              index == listOfMessages.length - 1 ? true : false,
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: greyFontColor,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                height: 50,
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: messageController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(15, 4, 0, 4),
                          hintText: 'Enter message',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        icon: Icon(Icons.send_outlined),
                        onPressed: () {
                          if (messageController.text != '') {
                            // List previous = openData.get(currentChat.chatID);
                            String encodedMessage = messageEncoder(
                                currentChat.chatID,
                                currentUser.userID,
                                messageController.text);
                            SocketConnection.instance
                                .sendMessage(encodedMessage);
                            // previous.add(encodedMessage);
                            // openData.put(currentChat.chatID, previous);
                            messageController.text = '';
                          }

                          // setState(() {
                          //   listOfMessages.add(messageController.text);
                          //   messageController.text = '';
                          // });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
