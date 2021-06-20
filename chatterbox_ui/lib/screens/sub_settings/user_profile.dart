import 'package:chatterbox_ui/backend_supporters/connections.dart';
import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/styles/font_styles.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  TextEditingController userNameController = TextEditingController();
  double _tickContainerNameWidth = 0;
  double _tickIconNameWidth = 0;
  late AnimationController _tickAnimationNameController;
  late Animation _tickAnimationName;

  TextEditingController passwordController = TextEditingController();
  double _tickContainerPasswordWidth = 0;
  double _tickIconPasswordWidth = 0;
  late AnimationController _tickAnimationPasswordController;
  late Animation _tickAnimationPassword;

  TextEditingController joinedOnController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userNameController.text = currentUser.username;
    passwordController.text = '';
    _tickAnimationNameController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _tickAnimationName = Tween<double>(begin: 0, end: 45).animate(
        CurvedAnimation(
            parent: _tickAnimationNameController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          _tickContainerNameWidth = _tickAnimationName.value;
          _tickIconNameWidth = (2 * _tickAnimationName.value) / 3;
        });
      });

    _tickAnimationPasswordController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _tickAnimationPassword = Tween<double>(begin: 0, end: 45).animate(
        CurvedAnimation(
            parent: _tickAnimationPasswordController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          _tickContainerPasswordWidth = _tickAnimationPassword.value;
          _tickIconPasswordWidth = (2 * _tickAnimationPassword.value) / 3;
        });
      });

    joinedOnController.text = currentUser.joinedOn;
  }

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    _tickAnimationNameController.dispose();
    _tickAnimationPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background11.jpg'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 40,
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
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _userName(),
                    _password(),
                    _joinedOn(),
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
              child: Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(currentUser.username + ' : User',
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

  _userName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Container(
          height: 75,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black,
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0.0, 0.0))
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 1),
                child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: currentTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'Username',
                              style: infoTitleTheme,
                              maxLines: 1,
                            )))),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          maxLines: null,
                          controller: userNameController,
                          onChanged: (changedText) {
                            _tickAnimationNameController.forward();
                          },
                          style: TextStyle(
                            color: currentTheme.textFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 24.0,
                            fontFamily: 'Pacifico',
                          )),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  width: _tickContainerNameWidth,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Icon(Icons.check_circle,
                        color: currentTheme.backgroundColor,
                        size: _tickIconNameWidth),
                  ),
                ),
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Updating credentials!')));
                  bool changed = await usernameUpdate(
                      newUsername: userNameController.text);
                  if (changed == false) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Username exists. Please choose another username!')));
                  } else
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Username updated!'),
                    ));
                  _tickAnimationNameController.reverse();
                },
              ),
            ],
          )),
    );
  }

  _password() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Container(
          height: 75,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black,
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0.0, 0.0))
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 1),
                child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: currentTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'Password',
                              style: infoTitleTheme,
                              maxLines: 1,
                            )))),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: passwordController,
                          onChanged: (changedText) {
                            _tickAnimationPasswordController.forward();
                          },
                          obscureText: true,
                          style: TextStyle(
                            color: currentTheme.textFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 24.0,
                            fontFamily: 'Pacifico',
                          )),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  width: _tickContainerPasswordWidth,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Icon(Icons.check_circle,
                        color: currentTheme.backgroundColor,
                        size: _tickIconPasswordWidth),
                  ),
                ),
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Updating credentials!')));
                  await passwordUpdate(newPassword: passwordController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password changed!')));
                  _tickAnimationPasswordController.reverse();
                },
              ),
            ],
          )),
    );
  }

  _joinedOn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Container(
          height: 75,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black,
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0.0, 0.0))
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 1),
                child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: currentTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'Joined On',
                              style: infoTitleTheme,
                              maxLines: 1,
                            )))),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          enabled: false,
                          controller: joinedOnController,
                          style: TextStyle(
                            color: currentTheme.textFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 24.0,
                            fontFamily: 'Pacifico',
                          )),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
