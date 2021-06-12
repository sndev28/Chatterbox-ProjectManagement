import 'package:chatterbox_ui/models/globals.dart';
import 'package:flutter/material.dart';
import '../../styles/font_styles.dart';

class SettingsThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  defaultCardWithSubtitle('Current theme', 'Material Theme'),
                  defaultCardWithSubtitle('Color', 'Red'),
                ],
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 40, bottom: 7),
                  child: Text('Theme', style: homeUserStyle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget defaultCardWithSubtitle(
    String cardTitle,
    String cardSubTitle,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Card(
          elevation: 12,
          color: currentTheme.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
            title: Text(
              cardTitle,
              style: bodyTheme,
            ),
            subtitle: Text(
              cardSubTitle,
              style: subTitleTheme,
            ),
          )),
    );
  }
}
