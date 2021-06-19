import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../styles/font_styles.dart';
import '../../models/globals.dart';
import '../../navigations.dart';
import '../../models/chat.dart';
import '../../backend_supporters/connections.dart';
import 'dart:convert';

class ChatTab extends StatefulWidget {
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  late ValueListenable<List> chatListValueListener =
      ValueNotifier<List>(chatList);

  bool chatsRetrieved = false;

  @override
  void initState() {
    super.initState();
    projectUpdate();
  }

  chatInitializer() async {
    chatList = [];
    final List<String> chatIDsFromDatabase =
        currentProject.projectChatList.split(',');

    for (var chatID in chatIDsFromDatabase) {
      if (chatID != '') {
        Chat newChat = await retrieveChatFromID(chatID);
        chatList.add(newChat);
      }
      chatsRetrieved = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController chatNameController = TextEditingController();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background3.jpg'),
            fit: BoxFit.cover),
      ),
      child: FutureBuilder(
          future: chatInitializer(),
          builder: (context, snapshot) {
            if (chatsRetrieved &&
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Text(snapshot.error.toString());
              else {
                chatsRetrieved = false;
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  floatingActionButton: FloatingActionButton(
                    shape: CircleBorder(
                        side: BorderSide(color: Colors.transparent)),
                    foregroundColor: currentTheme.secondaryColor,
                    backgroundColor: Colors.black38,
                    elevation: 4,
                    child: Center(
                      child: Icon(Icons.add, size: 50),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Container(
                                    height: 350,
                                    width: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          height: 300,
                                          width: 100,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Center(
                                                  child: Text(
                                                'Create Chat',
                                                style:
                                                    createProjectDialogueHeadingTheme,
                                              )),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  controller:
                                                      chatNameController,
                                                  decoration: InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(),
                                                      contentPadding:
                                                          EdgeInsets.all(8.0),
                                                      labelText: 'Chat Name',
                                                      hintText:
                                                          'Enter chat name',
                                                      suffixIcon:
                                                          Icon(Icons.edit)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    currentTheme.primaryColor,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 2.0,
                                                    spreadRadius: 0.0,
                                                    offset: Offset(0.0,
                                                        0.0), // shadow direction: bottom right
                                                  )
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.grey[800],
                                                size: 40,
                                              ),
                                            ),
                                            onTap: () async {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Chat is being created!'),
                                                duration: Duration(seconds: 2),
                                              ));
                                              final response =
                                                  await chatCreator(
                                                      chatName:
                                                          chatNameController
                                                              .text);

                                              String resultText =
                                                  'Chat could not be created!';

                                              if (response[0] == '200') {
                                                resultText = 'Chat created!';
                                                Map responseJson =
                                                    jsonDecode(response[1]);
                                                Chat newChat = Chat(
                                                    chatID:
                                                        responseJson['chatID'],
                                                    chatName: responseJson[
                                                        'chatName'],
                                                    members: responseJson[
                                                        'members']);
                                                projectUpdate();
                                                await chatInitializer();
                                                setState(() {});
                                                openData.put(
                                                    newChat.chatID, <String>[]);
                                                Navigator.pop(context);
                                                chatNameController.text = '';
                                              }

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(resultText),
                                                duration: Duration(seconds: 4),
                                              ));
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                              ));
                    },
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 80),
                              child: ReorderableListView.builder(
                                  itemCount: chatList.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  onReorder: (oldIndex, newIndex) {
                                    setState(() {
                                      if (newIndex > oldIndex) {
                                        newIndex = newIndex - 1;
                                      }
                                      final element =
                                          chatList.removeAt(oldIndex);
                                      chatList.insert(newIndex, element);
                                    });
                                  },
                                  padding: EdgeInsets.all(16.0),
                                  itemBuilder: (context, index) =>
                                      _cardGenerator(chatList[index])),
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

  Widget _cardGenerator(Chat chat) {
    String cardTitle = chat.chatName;
    String key = chat.chatID;

    return Padding(
      key: Key(key),
      padding: const EdgeInsets.only(top: 20),
      child: InkWell(
        child: Card(
          elevation: 12,
          color: currentTheme.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.drag_handle,
                  color: Colors.red[200],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 125),
                  child: Text(
                    cardTitle,
                    style: chatCardSubTitleTheme,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey[900],
            ),
            onTap: () async {
              currentChat = chat;
              await SocketConnection.instance.sendMessage(messageEncoder(
                  '_SystemMessage:NewChatOpened',
                  currentChat.chatID,
                  currentChat.members));
              Navigator.pushNamed(context, CHATDIR);
            },
          ),
        ),
      ),
    );
  }
}
