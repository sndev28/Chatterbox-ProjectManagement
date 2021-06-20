import 'package:chatterbox_ui/backend_supporters/connections.dart';
import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/styles/font_styles.dart';
import 'package:flutter/material.dart';

class ProjectSettingsProjectPage extends StatefulWidget {
  const ProjectSettingsProjectPage({Key? key}) : super(key: key);

  @override
  _ProjectSettingsProjectPageState createState() =>
      _ProjectSettingsProjectPageState();
}

class _ProjectSettingsProjectPageState extends State<ProjectSettingsProjectPage>
    with TickerProviderStateMixin {
  TextEditingController projectNameController = TextEditingController();
  double _tickContainerNameWidth = 0;
  double _tickIconNameWidth = 0;
  late AnimationController _tickAnimationNameController;
  late Animation _tickAnimationName;
  TextEditingController projectRepoLinkController = TextEditingController();
  double _tickContainerRepoLinkWidth = 0;
  double _tickIconRepoLinkWidth = 0;
  late AnimationController _tickAnimationRepoLinkController;
  late Animation _tickAnimationRepoLink;
  TextEditingController projectDescriptionController = TextEditingController();
  double _tickContainerDescriptionWidth = 0;
  double _tickIconDescriptionWidth = 0;
  late AnimationController _tickAnimationDescriptionController;
  late Animation _tickAnimationDescription;

  @override
  void initState() {
    super.initState();
    projectNameController.text = currentProject.projectName;
    projectDescriptionController.text = currentProject.projectDescription;
    projectRepoLinkController.text = currentProject.projectRepoLink;
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

    _tickAnimationRepoLinkController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _tickAnimationRepoLink = Tween<double>(begin: 0, end: 45).animate(
        CurvedAnimation(
            parent: _tickAnimationRepoLinkController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          _tickContainerRepoLinkWidth = _tickAnimationRepoLink.value;
          _tickIconRepoLinkWidth = (2 * _tickAnimationRepoLink.value) / 3;
        });
      });

    _tickAnimationDescriptionController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _tickAnimationDescription = Tween<double>(begin: 0, end: 45).animate(
        CurvedAnimation(
            parent: _tickAnimationDescriptionController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          _tickContainerDescriptionWidth = _tickAnimationDescription.value;
          _tickIconDescriptionWidth = (2 * _tickAnimationDescription.value) / 3;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    projectNameController.dispose();
    _tickAnimationNameController.dispose();
    _tickAnimationRepoLinkController.dispose();
    _tickAnimationDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background5.jpg'),
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
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _projectName(),
                    _projectRepoLink(),
                    _projectDescription(),
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
              child: Padding(
                padding: EdgeInsets.only(left: 25, bottom: 7, right: 25),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(currentProject.projectName + ' : Project',
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

  _projectName() {
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
                              'Name',
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                          maxLines: null,
                          controller: projectNameController,
                          onChanged: (changedText) {
                            _tickAnimationNameController.forward();
                          },
                          style: TextStyle(
                            color: currentTheme.textFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Updating in progress!'),
                    duration: Duration(seconds: 2),
                  ));
                  await projectValueUpdater(
                          updateDetail: 'projectName',
                          updationValue: projectNameController.text)
                      .then((value) {
                    setState(() {});
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Updation done!'),
                    duration: Duration(seconds: 1),
                  ));
                  _tickAnimationNameController.reverse();
                },
              ),
            ],
          )),
    );
  }

  _projectRepoLink() {
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
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'RepoLink',
                                style: infoTitleTheme,
                                maxLines: 1,
                              ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                          maxLines: 1,
                          controller: projectRepoLinkController,
                          onChanged: (changedText) {
                            _tickAnimationRepoLinkController.forward();
                          },
                          style: TextStyle(
                            color: currentTheme.textFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                            fontFamily: 'Pacifico',
                          )),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  width: _tickContainerRepoLinkWidth,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Icon(Icons.check_circle,
                        color: currentTheme.backgroundColor,
                        size: _tickIconRepoLinkWidth),
                  ),
                ),
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Updating in progress!'),
                    duration: Duration(seconds: 2),
                  ));
                  await projectValueUpdater(
                          updateDetail: 'projectRepoLink',
                          updationValue: projectRepoLinkController.text)
                      .then((value) {
                    setState(() {});
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Updation done!'),
                    duration: Duration(seconds: 1),
                  ));
                  _tickAnimationRepoLinkController.reverse();
                },
              ),
            ],
          )),
    );
  }

  _projectDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Container(
          height: 500,
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
                              'Description',
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
                          controller: projectDescriptionController,
                          onChanged: (changedText) {
                            _tickAnimationDescriptionController.forward();
                          },
                          style: TextStyle(
                            color: currentTheme.textFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                            fontFamily: 'Pacifico',
                          )),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  width: _tickContainerDescriptionWidth,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Icon(Icons.check_circle,
                        color: currentTheme.backgroundColor,
                        size: _tickIconDescriptionWidth),
                  ),
                ),
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Updating in progress!'),
                    duration: Duration(seconds: 2),
                  ));
                  await projectValueUpdater(
                          updateDetail: 'projectDescription',
                          updationValue: projectDescriptionController.text)
                      .then((value) {
                    setState(() {});
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Updation done!'),
                    duration: Duration(seconds: 1),
                  ));
                  _tickAnimationDescriptionController.reverse();
                },
              ),
            ],
          )),
    );
  }
}
