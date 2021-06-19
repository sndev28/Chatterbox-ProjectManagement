import 'dart:convert';

class Project {
  String projectID = '';
  String projectName = '';
  String projectCreatedOn = '';
  String projectRepoLink = '';
  String projectAdmin = '';
  String projectMembers = '';
  String projectDescription = '';
  String projectChatList = '';
  String projectTasks = '';

  Project(
      {projectID,
      projectName,
      projectCreatedOn,
      projectRepoLink,
      projectAdmin,
      projectDescription}) {
    this.projectID = projectID;
    this.projectName = projectName;
    this.projectCreatedOn = projectCreatedOn;
    this.projectRepoLink = projectRepoLink;
    this.projectAdmin = projectAdmin;
    this.projectDescription = projectDescription;
  }

  initializeFromJSON(String json) {
    Map givenData = jsonDecode(json);
    givenData['projectRepoLink'] ??= '';
    givenData['projectMembers'] ??= '';
    givenData['projectDescription'] ??= '';
    givenData['projectChatList'] ??= '';
    givenData['projectTasks'] ??= '';

    this.projectID = givenData['projectID'];
    this.projectName = givenData['projectName'];
    this.projectCreatedOn = givenData['projectCreatedOn'];
    this.projectRepoLink = givenData['projectRepoLink'];
    this.projectAdmin = givenData['projectAdmin'];
    this.projectMembers = givenData['projectMembers'];
    this.projectDescription = givenData['projectDescription'];
    this.projectChatList = givenData['projectChatList'];
    this.projectTasks = givenData['projectTasks'];
  }

  String details() {
    if (this.projectDescription != '')
      return this.projectDescription +
          '\nCreated On : ' +
          this.projectCreatedOn;
    return 'Created On : ' + this.projectCreatedOn;
  }

  String mindetails() {
    if (this.projectDescription != '') {
      if (this.projectDescription.length > 35) {
        return this.projectDescription.substring(0, 35) +
            '...' +
            '\nCreated On : ' +
            this.projectCreatedOn;
      }
      return this.projectDescription +
          '\nCreated On : ' +
          this.projectCreatedOn;
    }

    return 'Created On : ' + this.projectCreatedOn;
  }
}
