import 'package:flutter/material.dart';
import '../navigations.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController textController = TextEditingController();

  _test(BuildContext context) {
    Navigator.pushNamed(context, CHATDIR,
        arguments: <String, dynamic>{'window': textController.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: textController,
            ),
          ),
          IconButton(onPressed: () => _test(context), icon: Icon(Icons.send))
        ],
      ),
    ));
  }
}
