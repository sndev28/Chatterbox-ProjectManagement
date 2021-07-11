import 'dart:async';
import 'dart:convert';
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
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(milliseconds: 150),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background10.jpg'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
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
                padding: EdgeInsets.only(bottom: 7),
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
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Center(
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child:
                            Text(currentChat.chatName, style: homeChatStyle))),
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
                      Timer(
                          Duration(milliseconds: 150),
                          () => _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent));
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: listOfMessages.length,
                        itemBuilder: (context, index) {
                          Map message = jsonDecode(listOfMessages[index]);
                          return BubbleNormal(
                            text: message['message'],
                            subText:
                                chatUsers[message['userID']]?.username ?? '',
                            isSender: message['userID'] == currentUser.userID
                                ? true
                                : false,
                            color: message['userID'] == currentUser.userID
                                ? Color(0xFFFCE4EC)
                                : Colors.white,
                            tail: index == listOfMessages.length - 1
                                ? true
                                : false,
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
                              String encodedMessage = messageEncoder(
                                  currentChat.chatID,
                                  currentUser.userID,
                                  messageController.text);
                              SocketConnection.instance
                                  .sendMessage(encodedMessage);

                              messageController.text = '';
                              Timer(
                                  Duration(milliseconds: 150),
                                  () => _scrollController.jumpTo(
                                      _scrollController
                                          .position.maxScrollExtent));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

const double BUBBLE_RADIUS = 16;

class BubbleNormal extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final String text;
  final String subText;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle;
  final TextStyle subTextStyle;

  BubbleNormal({
    Key? key,
    required this.text,
    this.subText = '',
    this.bubbleRadius = BUBBLE_RADIUS,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    this.subTextStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 10,
    ),
  }) : super(key: key);

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Row(
      children: <Widget>[
        isSender
            ? Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Container(
          color: Colors.transparent,
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(bubbleRadius),
                  topRight: Radius.circular(bubbleRadius),
                  bottomLeft: Radius.circular(tail
                      ? isSender
                          ? bubbleRadius
                          : 0
                      : BUBBLE_RADIUS),
                  bottomRight: Radius.circular(tail
                      ? isSender
                          ? 0
                          : bubbleRadius
                      : BUBBLE_RADIUS),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: stateTick
                        ? EdgeInsets.fromLTRB(12, 6, 28, 6)
                        : EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          subText,
                          style: subTextStyle,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          text,
                          style: textStyle,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  stateIcon != null && stateTick
                      ? Positioned(
                          bottom: 4,
                          right: 6,
                          child: stateIcon,
                        )
                      : SizedBox(
                          width: 1,
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
