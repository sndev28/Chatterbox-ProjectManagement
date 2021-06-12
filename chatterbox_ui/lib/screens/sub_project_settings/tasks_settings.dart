import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/styles/font_styles.dart';
import 'package:flutter/material.dart';

class ProjectSettingsTasksPage extends StatefulWidget {
  const ProjectSettingsTasksPage({Key? key}) : super(key: key);

  @override
  _ProjectSettingsTasksPageState createState() =>
      _ProjectSettingsTasksPageState();
}

class _ProjectSettingsTasksPageState extends State<ProjectSettingsTasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: currentTheme.secondaryColor,
        foregroundColor: currentTheme.secondaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: currentTheme.backgroundColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            decoration: BoxDecoration(
              color: currentTheme.secondaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0,
                  spreadRadius: 3.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25, bottom: 7),
                  child: Text(currentProject.projectName + ' : Tasks',
                      style: homeUserStyle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
