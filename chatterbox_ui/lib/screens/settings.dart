import 'package:chatterbox_ui/models/globals.dart';
import 'package:flutter/material.dart';
import '../styles/font_styles.dart';
import '../navigations.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background6.jpg'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 40,
          elevation: 0,
          backgroundColor: currentTheme.secondaryColor,
          foregroundColor: currentTheme.secondaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: currentTheme.backgroundColor,
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(12, 80, 12, 12),
                  children: [
                    _navigationManager('Profile', context, settingsProfileDir),
                    _navigationManager('Themes', context, settingsThemesDir),
                    _navigationManager('Info', context, settingsInfoDir),
                    _logout(context),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 95,
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
                    padding: EdgeInsets.only(right: 40, bottom: 7, left: 40),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('Settings', style: homeUserStyle)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          elevation: 12,
          color: currentTheme.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
            title: Text(
              'LogOut',
              style: bodyTheme,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              color: currentTheme.backgroundColor,
            ),
            onTap: () {
              currentChat.empty();
              currentProject.empty();
              currentUser.empty();
              Navigator.pushNamedAndRemoveUntil(
                  context, LOGINDIR, (_) => false);
              SocketConnection.instance.closer();
            },
          ),
        ));
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
