import 'dart:convert';

class Chat {
  String chatID = '';
  String members = '';
  String chatName = '';

  Chat({chatID, chatName, members}) {
    this.chatID = chatID;
    this.chatName = chatName;
  }

  initializeFromJSON(String json) {
    Map givenData = jsonDecode(json);
    givenData['members'] ??= '';
    this.chatID = givenData['chatID'];
    this.members = givenData['members'];
    this.chatName = givenData['chatName'];
  }

  empty() {
    this.chatID = '';
    this.members = '';
    this.chatName = '';
  }
}
