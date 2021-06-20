import 'package:chatterbox_ui/backend_supporters/connections.dart';
import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/models/user.dart';
import 'package:chatterbox_ui/styles/font_styles.dart';
import 'package:flutter/material.dart';

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
  TextEditingController searchController = TextEditingController();

  late Future test;

  double _sizeOfSearch = 0;
  double ifTextChanged = 0;

  bool membersRetrieved = false;
  bool searchOpened = false;
  double heightOfDropdown = 150;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
    _controller.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background2.jpg'),
              fit: BoxFit.cover)),
      child: FutureBuilder(
          future: test,
          builder: (context, snapshot) {
            if (membersRetrieved &&
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
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 125),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: _sizeOfSearch + 80),
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
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            searchOpened
                                                ? memberSearch(
                                                    searchController.text)
                                                : _controller.forward();
                                            searchOpened = !searchOpened;
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: currentTheme.primaryColor,
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
                                              color:
                                                  currentTheme.backgroundColor,
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
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  child: Center(
                                                child: TextField(
                                                  controller: searchController,
                                                  autofocus: true,
                                                  onChanged:
                                                      (changedString) async {
                                                    if (changedString.isEmpty)
                                                      ifTextChanged = 0;
                                                    else {
                                                      ifTextChanged =
                                                          heightOfDropdown;
                                                      await memberSearch(
                                                          changedString);
                                                    }
                                                    setState(() {});
                                                  },
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            searchOpened
                                                ? _controller.reverse()
                                                : _controller.forward();
                                            searchOpened = !searchOpened;
                                            searchController.text = '';
                                            ifTextChanged = 0;
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: currentTheme.primaryColor,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(80),
                                                bottomRight:
                                                    Radius.circular(80),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 0,
                                                  spreadRadius:
                                                      0, // shadow direction: bottom right
                                                )
                                              ],
                                            ),
                                            child: searchOpened
                                                ? Icon(
                                                    Icons
                                                        .arrow_back_ios_new_sharp,
                                                    color: currentTheme
                                                        .backgroundColor,
                                                  )
                                                : Icon(
                                                    Icons.group_add_outlined,
                                                    color: currentTheme
                                                        .backgroundColor,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: _sizeOfSearch,
                                      height: ifTextChanged,
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(top: 10),
                                        primary: false,
                                        shrinkWrap: true,
                                        itemCount: searchMatches.length,
                                        itemBuilder: (context, index) {
                                          bool exists = false;
                                          List usernames = [
                                            for (var user
                                                in currentProjectMembersList)
                                              user.username
                                          ];
                                          if (usernames
                                              .contains(searchMatches[index]))
                                            exists = true;
                                          return Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: index % 2 == 1
                                                    ? Colors.grey[200]
                                                    : Colors.white),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    searchMatches[index],
                                                    style: dropDownTextStyle,
                                                  ),
                                                ),
                                                exists
                                                    ? IconButton(
                                                        icon: Icon(
                                                          Icons.delete_outline,
                                                          color: currentTheme
                                                              .backgroundColor,
                                                        ),
                                                        onPressed: () async {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                'Deletion under progress!'),
                                                            duration: Duration(
                                                                seconds: 4),
                                                          ));
                                                          await memberDelete(
                                                              username:
                                                                  searchMatches[
                                                                      index]);
                                                          setState(() {});
                                                        },
                                                      )
                                                    : IconButton(
                                                        icon: Icon(
                                                          Icons.add,
                                                          color: currentTheme
                                                              .backgroundColor,
                                                        ),
                                                        onPressed: () async {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                'Adding member!'),
                                                            duration: Duration(
                                                                seconds: 4),
                                                          ));
                                                          await memberAdd(
                                                              username:
                                                                  searchMatches[
                                                                      index]);
                                                          setState(() {});
                                                        },
                                                      ),
                                              ],
                                            ),
                                          );
                                        },
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
                                  itemBuilder: (context, index) =>
                                      _cardGenerator(
                                          currentProjectMembersList[index])),
                            ),
                          ],
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
                                alignment: Alignment.centerRight,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                      currentProject.projectName + ' : Members',
                                      style: homeUserStyle),
                                ),
                              ),
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
          }),
    );
  }

  memberInitializer() async {
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
    membersRetrieved = true;
  }

  Widget _cardGenerator(User member) {
    return Padding(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Card(
          elevation: 12,
          color: currentTheme.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
            title: Text(
              member.username,
              style: bodyTheme,
            ),
            trailing: Icon(
              Icons.delete_outlined,
              color: currentTheme.backgroundColor,
            ),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Deletion under progress!'),
                duration: Duration(seconds: 4),
              ));
              await memberDelete(userID: member.userID);
              setState(() {});
            },
          ),
        ));
  }
}
