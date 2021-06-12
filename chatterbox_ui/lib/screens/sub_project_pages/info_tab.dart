import 'dart:math';

import 'package:chatterbox_ui/backend_supporters/connections.dart';
import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/models/user.dart';
import 'package:chatterbox_ui/styles/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InfoTab extends StatefulWidget {
  @override
  _InfoTabState createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  String admin = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
              child: Column(
            children: [
              _projectName(),
              _projectDescription(),
              _projectAdmin(),
              _projectMembers()
            ],
          )),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initalizeDetails();
  }

  _initalizeDetails() async {
    List response = await retrieveUserFromID(currentProject.projectAdmin);
    User user = User();
    user.initializeFromJSON(response[1]);
    admin = user.username;
    List currentProjectMembersIDsList =
        currentProject.projectMembers.split(',');
    currentProjectMembersList = [];

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

    setState(() {});
  }

  _projectName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
      child: Container(
          height: 75,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black,
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0.0, 0.0))
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 1),
                child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: currentTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'Name',
                              style: infoTitleTheme,
                              maxLines: 1,
                            )))),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(currentProject.projectName,
                        style: infoSubTitleTheme),
                  ),
                ),
              )
            ],
          )),
    );
  }

  _projectDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
      child: Container(
          height: 100,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black,
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0.0, 0.0))
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 1),
                child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: currentTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'Description',
                              style: infoTitleTheme,
                              maxLines: 1,
                            )))),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      child: Text(currentProject.projectDescription,
                          // textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: currentTheme.textFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                            fontFamily: 'Pacifico',
                          )),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  _projectAdmin() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
      child: Container(
          height: 75,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black,
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0.0, 0.0))
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 1),
                child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: currentTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'Admin',
                              style: infoTitleTheme,
                            )))),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(admin, style: infoSubTitleTheme),
                  ),
                ),
              )
            ],
          )),
    );
  }

  _projectMembers() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
      child: Container(
          height: 300,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black,
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0.0, 0.0))
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 1),
                child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: currentTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'Members',
                              style: infoTitleTheme,
                              maxLines: 1,
                            )))),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: currentProjectMembersList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Align(
                                alignment: index % 2 == 1
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Transform.rotate(
                                  angle: index % 2 == 1 ? -pi / 4 : pi / 4,
                                  child: Text(
                                    currentProjectMembersList[index].username,
                                    style: TextStyle(
                                      color: currentTheme.textFontColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24.0,
                                      fontFamily: 'Pacifico',
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
