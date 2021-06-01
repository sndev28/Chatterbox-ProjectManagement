import 'package:chatterbox_ui/models/globals.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentChat.chatName),
      ),
    );
  }
}
