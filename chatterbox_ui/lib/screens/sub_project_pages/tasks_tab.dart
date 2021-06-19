import 'package:chatterbox_ui/backend_supporters/connections.dart';
import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/styles/font_styles.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:hive/hive.dart';

class TasksTab extends StatefulWidget {
  @override
  _TasksTabState createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  bool tasksRetrieved = false;
  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    projectUpdate();
    tasksList = currentProject.projectTasks.split(SEPERATOR);
    tasksList.remove('');
  }

  @override
  dispose() {
    super.dispose();
    _taskController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background9.jpg'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 120, 25, 0),
                    child: Container(
                      height: 75,
                      decoration: BoxDecoration(
                          color: currentTheme.lighterPrimaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Center(
                              child: TextField(
                                maxLines: null,
                                controller: _taskController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter task',
                                  labelText: 'Tasks',
                                ),
                              ),
                            ),
                          )),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              if (tasksList.contains(_taskController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Task exists! Please create another task!')));
                              } else {
                                await tasksAdd(_taskController.text);
                              }
                              _taskController.text = '';
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  ReorderableListView.builder(
                      itemCount: tasksList.length,
                      primary: false,
                      shrinkWrap: true,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex = newIndex - 1;
                          }
                          final element = tasksList.removeAt(oldIndex);
                          tasksList.insert(newIndex, element);
                        });
                      },
                      padding: EdgeInsets.all(16.0),
                      itemBuilder: (context, index) =>
                          _cardGenerator(tasksList[index])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardGenerator(String task) {
    return Padding(
      key: Key(task),
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
                  color: currentTheme.backgroundColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 125),
                  child: Text(
                    task,
                    style: chatCardSubTitleTheme,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.delete_outline_outlined,
              color: currentTheme.backgroundColor,
            ),
            onTap: () async {
              await tasksDelete(task);
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
