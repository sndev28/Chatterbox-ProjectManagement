import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/navigations.dart';
import 'package:chatterbox_ui/styles/font_styles.dart';
import 'package:flutter/material.dart';

class ProjectSettingsPage extends StatelessWidget {
  const ProjectSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background1.jpg'),
              fit: BoxFit.cover)),
      child: Scaffold(
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
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _navigationManager(
                          'Project', context, projectSettingsProject),
                      _navigationManager(
                          'Members', context, projectSettingsMembers),
                      _navigationManager(
                          'Tasks', context, projectSettingsTasks),
                      _navigationManager(
                          'Chats', context, projectSettingsChats),
                    ],
                  ),
                ),
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
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 25, bottom: 7, right: 25),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(currentProject.projectName + ' : Settings',
                        style: homeUserStyle),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navigationManager(String navigationDestinationTitle,
      BuildContext context, String navigationDestination) {
    return Padding(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Card(
          elevation: 12,
          color: currentTheme.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
            title: Text(
              navigationDestinationTitle,
              style: bodyTheme,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              color: currentTheme.backgroundColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, navigationDestination);
            },
          ),
        ));
  }
}
