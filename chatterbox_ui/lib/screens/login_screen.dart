import 'package:flutter/material.dart';
import '../styles/font_styles.dart';
import '../backend_supporters/connections.dart';
import '../navigations.dart';
import '../backend_supporters/globals.dart';

class LoginScreen extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  static String userMinDetails = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text('ChatterBox', style: loginAppTitleStyle),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
                child: Card(
                  elevation: 8,
                  color: Colors.red[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'pacifico'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 40),
                        child: TextField(
                          cursorColor: Colors.white,
                          controller: usernameController,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(8.0),
                              labelText: 'Username',
                              hintText: 'Enter username',
                              suffixIcon: Icon(Icons.person)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                        child: TextField(
                          cursorColor: Colors.white,
                          controller: passwordController,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(8.0),
                              labelText: 'Password',
                              hintText: 'Enter password',
                              suffixIcon: Icon(Icons.lock)),
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 50, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                child: Card(
                                  //Login Card
                                  elevation: 0,
                                  color: Colors.grey[900],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  final response = await userLogin(
                                      usernameController.text,
                                      passwordController.text);

                                  passwordController.text = '';

                                  String snackbarString;
                                  userMinDetails = response[1];

                                  int statusCode = int.parse(response[0]);

                                  switch (statusCode) {
                                    case 200:
                                      currentUser
                                          .initializeFromJSON(response[1]);
                                      snackbarString = 'Please wait...';
                                      break;
                                    case 404:
                                      snackbarString =
                                          'User not found. Please register!';
                                      break;
                                    case 401:
                                      snackbarString = 'Wrong Password.';
                                      break;
                                    default:
                                      snackbarString =
                                          'Error logging in. Try again later';
                                  }

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(snackbarString),
                                    duration: Duration(seconds: 2),
                                  ));
                                  if (statusCode == 200) _gotoChatDir(context);
                                }),
                            InkWell(
                                child: Card(
                                  // Register Card
                                  elevation: 0,
                                  color: Colors.grey[900],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  final responseCode = await newUserRegister(
                                      usernameController.text,
                                      passwordController.text);

                                  passwordController.text = '';

                                  String snackbarString;

                                  switch (responseCode) {
                                    case 200:
                                      snackbarString =
                                          'New user created. Please login with your credentials.';
                                      break;
                                    case 409:
                                      snackbarString =
                                          'Username already exists. Please use another username.';
                                      break;
                                    default:
                                      snackbarString =
                                          'Error in creating user.';
                                  }

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(snackbarString),
                                    duration: Duration(seconds: 4),
                                  ));
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _gotoChatDir(BuildContext context) {
    Navigator.pushReplacementNamed(context, HOMEDIR);
  }
}
