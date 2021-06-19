import 'dart:convert';
import 'package:hive/hive.dart';
import '../styles/font_styles.dart';
import 'package:flutter/material.dart';
import '../navigations.dart';
import '../backend_supporters/connections.dart';
import '../models/project.dart';
import '../models/globals.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Project> projectList = [];
  bool projectRetrieved = false;
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectDescriptionController =
      TextEditingController();
  final TextEditingController projectRepoLinkController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    userUpdate();
  }

  projectInitializer() async {
    // var now = DateTime.now();
    // String dmCreationTime = DateFormat.yMMMMd().add_Hm().format(now);
    openData = await Hive.openBox(currentUser.userID);
    SocketConnection.instance.initializeSocket();

    // Project directMessage = Project(
    //     projectID: 'DM',
    //     projectName: 'Direct Messages',
    //     projectCreatedOn: dmCreationTime,
    //     projectRepoLink: '',
    //     projectAdmin: currentUser.userID,
    //     projectDescription: 'Direct messages with friends');
    // projectList.add(directMessage);

    final List<String> projectIDsFromDatabase = currentUser.projects.split(',');
    projectList = [];
    for (var projectID in projectIDsFromDatabase) {
      if (projectID != '') {
        Project newProject = await retrieveProjectFromID(projectID);
        projectList.add(newProject);
      }
      projectRetrieved = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background4.jpg'),
              fit: BoxFit.cover)),
      child: FutureBuilder(
          future: projectInitializer(),
          builder: (context, snapshot) {
            if (projectRetrieved &&
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Text(snapshot.error.toString());
              else
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: currentTheme.secondaryColor,
                    foregroundColor: currentTheme.secondaryColor,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.settings_outlined,
                            color: currentTheme.backgroundColor),
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
                                  final element =
                                      projectList.removeAt(oldIndex);
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
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25, bottom: 7, right: 25),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child:
                                        Text('Projects', style: homeUserStyle)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    shape: CircleBorder(
                        side: BorderSide(color: Colors.transparent)),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black38,
                    elevation: 4,
                    child: Center(
                      child: Icon(Icons.add, size: 50),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Container(
                                    height: 350,
                                    width: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          height: 300,
                                          width: 100,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Center(
                                                  child: Text(
                                                'Create Project',
                                                style:
                                                    createProjectDialogueHeadingTheme,
                                              )),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  controller:
                                                      projectNameController,
                                                  decoration: InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(),
                                                      contentPadding:
                                                          EdgeInsets.all(8.0),
                                                      labelText: 'Project Name',
                                                      hintText:
                                                          'Enter project name',
                                                      suffixIcon:
                                                          Icon(Icons.edit)),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  maxLines: null,
                                                  controller:
                                                      projectDescriptionController,
                                                  decoration: InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(),
                                                      contentPadding:
                                                          EdgeInsets.all(8.0),
                                                      labelText:
                                                          'Project Description',
                                                      hintText:
                                                          'Enter project description',
                                                      suffixIcon:
                                                          Icon(Icons.edit)),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  controller:
                                                      projectRepoLinkController,
                                                  decoration: InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(),
                                                      contentPadding:
                                                          EdgeInsets.all(8.0),
                                                      labelText:
                                                          'Project Repo Link',
                                                      hintText:
                                                          'Enter project link(optional)',
                                                      suffixIcon:
                                                          Icon(Icons.edit)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    currentTheme.primaryColor,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 2.0,
                                                    spreadRadius: 0.0,
                                                    offset: Offset(0.0,
                                                        0.0), // shadow direction: bottom right
                                                  )
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.grey[800],
                                                size: 40,
                                              ),
                                            ),
                                            onTap: () async {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Project is being created!'),
                                                duration: Duration(seconds: 2),
                                              ));
                                              final response = await projectCreator(
                                                  projectName:
                                                      projectNameController
                                                          .text,
                                                  projectDescription:
                                                      projectDescriptionController
                                                          .text,
                                                  projectRepoLink:
                                                      projectRepoLinkController
                                                          .text,
                                                  projectAdmin:
                                                      currentUser.userID);

                                              String resultText =
                                                  'Project could not be created!';

                                              if (response[0] == '200') {
                                                resultText = 'Project created!';
                                                Map responseJson =
                                                    jsonDecode(response[1]);
                                                Project newProject = Project(
                                                    projectID: responseJson[
                                                        'projectID'],
                                                    projectName: responseJson[
                                                        'projectName'],
                                                    projectCreatedOn:
                                                        responseJson[
                                                            'projectCreatedOn'],
                                                    projectRepoLink:
                                                        responseJson[
                                                            'projectRepoLink'],
                                                    projectAdmin: responseJson[
                                                        'projectAdmin'],
                                                    projectDescription:
                                                        responseJson[
                                                            'projectDescription']);
                                                setState(() {
                                                  projectList.add(newProject);
                                                });
                                                Navigator.pop(context);
                                                projectNameController.text = '';
                                                projectDescriptionController
                                                    .text = '';
                                                projectRepoLinkController.text =
                                                    '';
                                              }
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(resultText),
                                                duration: Duration(seconds: 4),
                                              ));
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                              ));
                    },
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                );
            } else {
              return Scaffold(
                body: Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset(
                        'assets/images/meow.gif',
                      )),
                ),
              );
            }
          }),
    );
  }

  Widget _cardGenerator(Project project) {
    String cardTitle = project.projectName;
    String cardSubTitle = project.mindetails();
    String key = project.projectID;

    return Padding(
      key: Key(key),
      padding: const EdgeInsets.only(top: 20),
      child: InkWell(
        child: Card(
          elevation: 12,
          color: currentTheme.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(35))),
          child: Container(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.only(left: 3, top: 20, bottom: 10),
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.drag_handle,
                      color: currentTheme.lighterPrimaryColor,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
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
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios)),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          currentProject = project;
          Navigator.pushNamed(context, projectDir);
        },
      ),
    );
  }
}
