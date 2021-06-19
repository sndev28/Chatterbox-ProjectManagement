import 'package:chatterbox_ui/backend_supporters/connections.dart';
import 'package:chatterbox_ui/models/chat.dart';
import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/styles/font_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProjectSettingsChatsPage extends StatefulWidget {
  const ProjectSettingsChatsPage({Key? key}) : super(key: key);

  @override
  _ProjectSettingsChatsPageState createState() =>
      _ProjectSettingsChatsPageState();
}

class _ProjectSettingsChatsPageState extends State<ProjectSettingsChatsPage> {
  bool chatsRetrieved = false;
  @override
  Widget build(BuildContext context) {
    chatList = [];
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background12.jpg'),
              fit: BoxFit.cover)),
      child: FutureBuilder(
          future: chatInitializer(),
          builder: (context, snapshot) {
            if (chatsRetrieved == true &&
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Text(snapshot.error.toString());
              else {
                chatsRetrieved = false;
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
                        child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 64, vertical: 20),
                                    child: Card(
                                      elevation: 12,
                                      color: currentTheme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      child: ListTile(
                                        title: Text(
                                          'Delete all chats!',
                                          style: bodyTheme,
                                        ),
                                        trailing: Icon(
                                          Icons.delete_outlined,
                                          color: currentTheme.backgroundColor,
                                        ),
                                        onTap: () async {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Deletion under progress!'),
                                            duration: Duration(seconds: 4),
                                          ));
                                          List copyChatList = []
                                            ..addAll(chatList);
                                          for (var chat in copyChatList) {
                                            await chatDelete(
                                                chatID: chat.chatID);
                                          }
                                          chatList = [];

                                          setState(() {});
                                        },
                                      ),
                                    )),
                                ListView.builder(
                                    itemCount: chatList.length,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        _cardGenerator(chatList[index])),
                              ],
                            )),
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
                                      currentProject.projectName + ' : Chats',
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
              }
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

  chatInitializer() async {
    final List<String> chatIDsFromDatabase =
        currentProject.projectChatList.split(',');
    chatList = [];
    for (var chatID in chatIDsFromDatabase) {
      if (chatID != '') {
        Chat newChat = await retrieveChatFromID(chatID);
        chatList.add(newChat);
      }
      chatsRetrieved = true;
    }
  }

  Widget _cardGenerator(Chat chat) {
    return Padding(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Card(
          elevation: 12,
          color: currentTheme.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
            title: Text(
              chat.chatName,
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
              // chatList.remove(chat);
              await chatDelete(chatID: chat.chatID);
              setState(() {});
            },
          ),
        ));
  }
}
