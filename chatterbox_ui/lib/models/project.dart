import 'dart:convert';

class Project {
  String projectID = '';
  String projectName = '';
  String projectCreatedOn = '';
  String projectRepoLink = '';
  String projectAdmin = '';
  String projectMembers = '';
  String projectDescription = '';

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

    this.projectID = givenData['projectID'];
    this.projectName = givenData['projectName'];
    this.projectCreatedOn = givenData['projectCreatedOn'];
    this.projectRepoLink = givenData['projectRepoLink'];
    this.projectAdmin = givenData['projectAdmin'];
    this.projectMembers = givenData['projectMembers'];
    this.projectDescription = givenData['projectDescription'];
  }

  String details() {
    if (this.projectDescription != '')
      return this.projectDescription +
          '\nCreated On : ' +
          this.projectCreatedOn;
    return 'Created On : ' + this.projectCreatedOn;
  }
}
