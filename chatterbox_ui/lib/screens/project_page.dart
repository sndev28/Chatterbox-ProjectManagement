import 'package:chatterbox_ui/navigations.dart';
import 'package:flutter/material.dart';
import '../styles/font_styles.dart';
import '../models/globals.dart';
import 'sub_project_pages/chat_tab.dart';
import 'sub_project_pages/tasks_tab.dart';
import 'sub_project_pages/info_tab.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: currentTheme.secondaryColor,
            foregroundColor: currentTheme.secondaryColor,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: currentTheme.backgroundColor,
                )),
            actions: [
              IconButton(
                icon: Icon(Icons.settings_outlined,
                    color: currentTheme.backgroundColor),
                onPressed: () {
                  Navigator.pushNamed(context, projectSettingsDir)
                      .then((value) async {
                    setState(() {});
                  });
                },
              ),
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Container(height: 35, child: Icon(Icons.chat_outlined)),
              Container(height: 35, child: Icon(Icons.account_tree_outlined)),
              Container(height: 35, child: Icon(Icons.info_outline_rounded)),
            ],
          ),
          body: Stack(children: [
            TabBarView(children: [
              ChatTab(),
              TasksTab(),
              InfoTab(),
            ]),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                padding: EdgeInsets.only(bottom: 7),
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
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(currentProject.projectName,
                              style: homeUserStyle)),
                    ),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}
