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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey[900],
                )),
            actions: [
              IconButton(
                icon: Icon(Icons.settings_outlined, color: Colors.grey[900]),
                onPressed: () {
                  Navigator.pushNamed(context, projectSettingsDir);
                },
              ),
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Icon(Icons.chat_outlined),
              Icon(Icons.account_tree_outlined),
              Icon(Icons.info_outline_rounded),
            ],
          ),
          body: Stack(children: [
            TabBarView(children: [
              ChatTab(),
              TasksTab(),
              InfoTab(),
            ]),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 7),
                    child:
                        Text(currentProject.projectName, style: HomeUserStyle),
                  ),
                ],
              ),
            ),
          ])),
    );
  }
}
