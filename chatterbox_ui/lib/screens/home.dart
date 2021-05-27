import 'dart:convert';
import 'package:intl/intl.dart';

import '../styles/font_styles.dart';
import 'package:flutter/material.dart';
import '../navigations.dart';

class Project {
  String projectID = '';
  String projectName = '';
  String projectCreatedOn = '';
  String projectRepoLink = '';
  String projectAdmin = '';
  String projectMembers = '';
  String projectDescription = '';

  Project(this.projectID, this.projectName, this.projectCreatedOn,
      this.projectRepoLink, this.projectAdmin, this.projectDescription);

  String details() {
    if (this.projectDescription != '')
      return this.projectDescription +
          '\nCreated On : ' +
          this.projectCreatedOn;
    return 'Created On : ' + this.projectCreatedOn;
  }
}

class Home extends StatefulWidget {
  final String serverResponse;
  const Home(this.serverResponse);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userID = '', joinedOn = '';
  List<Project> projectList = [];

  @override
  void initState() {
    super.initState();
    final serverResponseObject = jsonDecode(widget.serverResponse);
    this.userID = serverResponseObject['user_id'];
    this.joinedOn = serverResponseObject['joined_on'];
    var now = DateTime.now();
    String dmCreationTime = DateFormat.yMMMMd().add_Hm().format(now);

    for (var i = 0; i < 20; i++) {
      Project directMessage = Project('DM' + i.toString(), 'Direct Messages',
          dmCreationTime, '', this.userID, 'Direct messages with friends');
      projectList.add(directMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Colors.grey[900]),
            onPressed: () {
              Navigator.pushNamed(context, SETTINGSDIR);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ReorderableListView.builder(
                  itemCount: projectList.length,
                  primary: false,
                  shrinkWrap: true,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex = newIndex - 1;
                      }
                      final element = projectList.removeAt(oldIndex);
                      projectList.insert(newIndex, element);
                    });
                  },
                  padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, index) =>
                      _cardGenerator(projectList[index])),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
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
                  child: Text('Projects', style: HomeUserStyle),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black38,
        elevation: 4,
        child: Center(
          child: Icon(Icons.add, size: 50),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => _createProjectDialog(context));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _cardGenerator(Project project) {
    String cardTitle = project.projectName;
    String cardSubTitle = project.details();
    String key = project.projectID;

    return Padding(
      key: Key(key),
      padding: const EdgeInsets.only(top: 20),
      child: Card(
        elevation: 12,
        color: Colors.red[400],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(35))),
        child: Container(
          height: 120,
          child: Padding(
            padding: const EdgeInsets.only(left: 3, top: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.drag_handle,
                  color: Colors.red[200],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 125),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cardTitle,
                        style: cardTitleTheme,
                      ),
                      Text(
                        cardSubTitle,
                        style: cardSubTitleTheme,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Dialog _createProjectDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        height: MediaQuery.of(context).size.height - 500,
        width: MediaQuery.of(context).size.width,
        child: Container(
            height: 350,
            width: 100,
            child: Stack(
              children: [
                Column(
                  children: [
                    Center(
                        child: Text(
                      'Create Project',
                      style: createProjectDialogueHeadingTheme,
                    )),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: TextField(
                        cursorColor: Colors.white,
                        // controller: usernameController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.all(8.0),
                            labelText: 'Project Name',
                            hintText: 'Enter project name',
                            suffixIcon: Icon(Icons.edit)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: TextField(
                        cursorColor: Colors.white,
                        // expands: true,
                        // minLines: null,
                        maxLines: null,
                        // controller: usernameController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.all(8.0),
                            labelText: 'Project Description',
                            hintText: 'Enter project description',
                            suffixIcon: Icon(Icons.edit)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: TextField(
                        cursorColor: Colors.white,
                        // controller: usernameController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.all(8.0),
                            labelText: 'Project Repo Link',
                            hintText: 'Enter project link(optional)',
                            suffixIcon: Icon(Icons.edit)),
                      ),
                    ),
                  ],
                ),
                // Padding(
                //     // padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                //     padding: EdgeInsets.only(top: 331),
                //     child: Center(
                //       child: IconButton(
                //         icon: Icon(
                //           Icons.add_circle_outline_outlined,
                //           color: Colors.red[900],
                //         ),
                //         onPressed: () {},
                //       ),
                //     )),

                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
