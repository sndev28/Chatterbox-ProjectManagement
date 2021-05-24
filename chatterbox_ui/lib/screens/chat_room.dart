import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  final String chatwindow;

  ChatRoom(this.chatwindow);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatwindow),
      ),
    );
  }
}
