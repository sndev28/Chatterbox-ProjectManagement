import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'navigations.dart';
import 'screens/chat_room.dart';
import 'screens/login_screen.dart';

class ChatterBox extends StatefulWidget {
  @override
  _ChatterBoxState createState() => _ChatterBoxState();
}

class _ChatterBoxState extends State<ChatterBox> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red[300],
        canvasColor: Colors.grey[900],
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _routes(),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final arguments = settings.arguments;

      Widget screen;

      switch (settings.name) {
        case LOGINDIR:
          screen = LoginScreen();
          break;

        case HOMEDIR:
          screen = Home();
          break;

        case CHATDIR:
          screen = ChatRoom(
              arguments is Map ? arguments['window'] : 'Invalid Argument');
          break;

        default:
          return null;
      }

      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
