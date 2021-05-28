import 'package:flutter/material.dart';
import '../styles/font_styles.dart';
import '../backend_supporters/globals.dart';

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
                  // Navigator.pushNamed(context, SETTINGSDIR);
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
              Container(),
              Center(child: Text('Dam2')),
              Center(child: Text('Dam3')),
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

  // Widget _cardGenerator(Chat chat) {
  //   String cardTitle = project.projectName;
  //   String cardSubTitle = project.details();
  //   String key = project.projectID;

  //   return Padding(
  //     key: Key(key),
  //     padding: const EdgeInsets.only(top: 20),
  //     child: InkWell(
  //       child: Card(
  //         elevation: 12,
  //         color: Colors.red[400],
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(35))),
  //         child: Container(
  //           height: 120,
  //           child: Padding(
  //             padding: const EdgeInsets.only(left: 3, top: 20, bottom: 10),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 Icon(
  //                   Icons.drag_handle,
  //                   color: Colors.red[200],
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 12, right: 125),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         cardTitle,
  //                         style: cardTitleTheme,
  //                       ),
  //                       Text(
  //                         cardSubTitle,
  //                         style: cardSubTitleTheme,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Icon(Icons.arrow_forward_ios),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       onTap: () {
  //         // currentProject = project;
  //         // Navigator.pushNamed(context, projectDir);
  //       },
  //     ),
  //   );
  // }
}
