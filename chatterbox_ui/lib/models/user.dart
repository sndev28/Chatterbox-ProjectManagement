import 'dart:convert';

class User {
  String username = '';
  String userID = '';
  String projects = '';
  String joinedOn = '';

  // User({userID, username, joinedOn, projects}) {
  //   this.userID = userID;
  //   this.username = username;
  //   this.joinedOn = joinedOn;
  //   this.projects = projects;
  // }

  initializeFromJSON(String json) {
    Map givenData = jsonDecode(json);
    this.userID = givenData['userID'];
    this.username = givenData['username'];
    this.projects = givenData['projects'];
    this.joinedOn = givenData['joinedOn'];
  }

  empty() {
    this.username = '';
    this.userID = '';
    this.projects = '';
    this.joinedOn = '';
  }
}
