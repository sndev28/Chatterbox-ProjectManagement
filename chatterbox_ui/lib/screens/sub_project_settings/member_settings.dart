import 'package:chatterbox_ui/backend_supporters/connections.dart';
import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/models/user.dart';
import 'package:chatterbox_ui/styles/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class ProjectSettingsMembersPage extends StatefulWidget {
  const ProjectSettingsMembersPage({Key? key}) : super(key: key);

  @override
  _ProjectSettingsMembersPageState createState() =>
      _ProjectSettingsMembersPageState();
}

class _ProjectSettingsMembersPageState extends State<ProjectSettingsMembersPage>
    with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _controller;
  late AsyncMemoizer memoizer;

  late Future test;

  double _sizeOfSearch = 0;

  bool membersRetrieved = false;

  @override
  void initState() {
    super.initState();
    memoizer = AsyncMemoizer();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 250)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease))
          ..addListener(() {
            setState(() {
              _sizeOfSearch = _animation.value;
            });
          });
    test = memberInitializer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: test,
        builder: (context, snapshot) {
          if (membersRetrieved &&
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.white,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.search_sharp),
                      onPressed: () {
                        print('To Be added');
                      },
                    )
                  ],
                  leading: IconButton(
                    icon:
                        Icon(Icons.arrow_back_ios_new, color: Colors.grey[900]),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 125),
                            child: Container(
                              constraints:
                                  BoxConstraints(maxWidth: _sizeOfSearch + 80),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 12.0,
                                    spreadRadius: 5.0,
                                    offset: Offset(2.0,
                                        2.0), // shadow direction: bottom right
                                  )
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _controller.forward();
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.red[400],
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(80),
                                          bottomLeft: Radius.circular(80),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 0,
                                            spreadRadius:
                                                0, // shadow direction: bottom right
                                          )
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.search_sharp,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: _sizeOfSearch,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 0,
                                          spreadRadius:
                                              0, // shadow direction: bottom right
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _controller.reverse();
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.red[400],
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(80),
                                          bottomRight: Radius.circular(80),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 0,
                                            spreadRadius:
                                                0, // shadow direction: bottom right
                                          )
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.group_add_outlined,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: ListView.builder(
                                itemCount: currentProjectMembersList.length,
                                primary: false,
                                shrinkWrap: true,
                                padding: EdgeInsets.all(16.0),
                                itemBuilder: (context, index) => _cardGenerator(
                                    currentProjectMembersList[index])),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: ListView.builder(
                                itemCount: currentProjectMembersList.length,
                                primary: false,
                                shrinkWrap: true,
                                padding: EdgeInsets.all(16.0),
                                itemBuilder: (context, index) => _cardGenerator(
                                    currentProjectMembersList[index])),
                          ),
                        ],
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
                            padding: EdgeInsets.only(left: 25, bottom: 7),
                            child: Text(
                                currentProject.projectName + ' : Members',
                                style: HomeUserStyle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
        });
  }

  memberInitializer() async => this.memoizer.runOnce(() async {
        List currentProjectMembersIDsList =
            currentProject.projectMembers.split(',');
        currentProjectMembersList = [];
        User tempUser = User();
        for (var memberID in currentProjectMembersIDsList) {
          if (memberID != '' && memberID != ' ') {
            final response = await retrieveUserFromID(memberID);
            if (int.parse(response[0]) == 200) {
              tempUser.initializeFromJSON(response[1]);
              currentProjectMembersList.add(tempUser.username);
            }
          }
        }
        membersRetrieved = true;
      });

  Widget _cardGenerator(String memberName) {
    return Padding(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Card(
          elevation: 12,
          color: Colors.red[400],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
            title: Text(
              memberName,
              style: bodyTheme,
            ),
            trailing: Icon(
              Icons.delete_outlined,
              color: Colors.grey[900],
            ),
            onTap: () {
              print('Delete..!?');
            },
          ),
        ));
  }
}
