from hashlib import new
from flask import Flask
from flask_restful import Api, Resource, reqparse, abort
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime
import random
import string
from requests import NullHandler
import time
from sqlalchemy.sql.elements import Null
import json


SEPERATOR = '<sep>'

app = Flask(__name__)
CORS(app)
api = Api(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///chatdatabase.db'
db = SQLAlchemy()
db.init_app(app)

with app.app_context():
    db.create_all()








#####################################################################################################################################





class ChatDetails(db.Model):
    chatID = db.Column(db.String, primary_key = True, nullable = False)
    chatName = db.Column(db.String)
    members = db.Column(db.String)

    def toJSON(self):
        return {
            'chatID': self.chatID,
            'chatName': self.chatName,
            'members': self.members
        }





chatArgs = reqparse.RequestParser()
chatArgs.add_argument('chatID', type = str, help = 'chatID not sent!')
chatArgs.add_argument('chatName', type = str, help = 'chatName not sent!')
chatArgs.add_argument('members', type = str, help = 'members not sent!')




class Chats(Resource):

    def put(self): #new chat
        args = chatArgs.parse_args()
        print(args)
        chatID = 'CH_ID_' + ''.join(random.choices(string.ascii_uppercase + string.digits, k = 15))
        newChat = ChatDetails(chatName = args['chatName'], chatID = chatID, members = args['members'])

        db.session.add(newChat)
        db.session.commit()
        return newChat.toJSON(), 200

    def post(self): # retrieve chat
        args = chatArgs.parse_args()
        print(args)

        retrieved_chat = ChatDetails.query.filter_by(chatID = args['chatID']).first()

        if not retrieved_chat:
            abort(404, message = 'Given chat not found')

        print(retrieved_chat.toJSON())
        return retrieved_chat.toJSON()







api.add_resource(Chats, '/chatdetails')















#####################################################################################################################################





class ProjectDetails(db.Model):
    projectID = db.Column(db.String, primary_key = True, nullable = False)
    projectName = db.Column(db.String, nullable = False)
    projectCreatedOn = db.Column(db.String, nullable = False)
    projectRepoLink = db.Column(db.String)
    projectAdmin = db.Column(db.String, nullable = False)
    projectMembers = db.Column(db.String)
    projectDescription = db.Column(db.String)
    projectChatList = db.Column(db.String)
    projectTasks = db.Column(db.String)


    def toJSON(self):
        return {
            'projectID': self.projectID,
            'projectName': self.projectName,
            'projectCreatedOn': self.projectCreatedOn,
            'projectRepoLink': self.projectRepoLink,
            'projectAdmin': self.projectAdmin,
            'projectMembers': self.projectMembers,
            'projectDescription': self.projectDescription,
            'projectChatList': self.projectChatList,
            'projectTasks': self.projectTasks
        }





projectDetailsArgs = reqparse.RequestParser()
projectDetailsArgs.add_argument('projectID', type = str, help = 'projectID not sent!')
projectDetailsArgs.add_argument('projectName', type = str, help = 'projectName not sent!')
projectDetailsArgs.add_argument('projectRepoLink', type = str, help = 'projectRepoLink not sent!')
projectDetailsArgs.add_argument('projectAdmin', type = str, help = 'projectAdmin not sent!')
projectDetailsArgs.add_argument('projectMembers', type = str, help = 'projectMembers not sent!')
projectDetailsArgs.add_argument('projectDescription', type = str, help = 'projectDescription not sent!')
projectDetailsArgs.add_argument('projectChatList', type = str, help = 'projectChatList not sent!')
projectDetailsArgs.add_argument('projectTasks', type = str, help = 'projectTasks not sent!')
projectDetailsArgs.add_argument('updateCommand', type = str, help = 'No update command sent')





class Projects(Resource):

    def put(self): #new project/updater
        args = projectDetailsArgs.parse_args()
        print(args)
        project = ProjectDetails.query.filter_by(projectID = args['projectID']).first()
        if project: #update project if it exists
            return project.toJSON()

        projectCreatedOn = datetime.now().strftime('%B %d, %Y %H:%M')
        projectID = 'PR_ID_' + ''.join(random.choices(string.ascii_uppercase + string.digits, k = 15))
        newProject = ProjectDetails(projectName = args['projectName'], projectAdmin = args['projectAdmin'], projectRepoLink = args['projectRepoLink'], projectDescription = args['projectDescription'], projectID = projectID, projectCreatedOn = projectCreatedOn)

        db.session.add(newProject)
        db.session.commit()

        return newProject.toJSON(), 200

    def post(self): # retrieve project
        args = projectDetailsArgs.parse_args()
        print(args)

        retrieved_project = ProjectDetails.query.filter_by(projectID = args['projectID']).first()

        if not retrieved_project:
            abort(404, message = 'Given project not found')

        print(retrieved_project.toJSON())
        return retrieved_project.toJSON()

    def patch(self): #update project
        args = projectDetailsArgs.parse_args()
        if not ProjectDetails.query.filter_by(projectID = args['projectID']).first(): #project doesnt exist
            print('Project doesnt exist!')
            abort(404, message = 'Project doesnt exist!')

        print('Project exists!')

        project = ProjectDetails.query.filter_by(projectID = args['projectID']).first()

        print('Project retrieved!')

        if args['updateCommand'] == 'chat':        
            if  project.projectChatList == None:
                project.projectChatList = args['projectChatList'] + ','
            else: project.projectChatList += args['projectChatList'] + ','
            db.session.commit()

        elif args['updateCommand'] == 'members_userID':
            if  project.projectMembers == None:
                project.projectMembers = args['projectMembers'] + ','
            else: project.projectMembers += args['projectMembers'] + ','
            db.session.commit()

        elif args['updateCommand'] == 'members_username':
            user = UserDetails.query.filter_by(username = args['projectMembers']).first()
            if user == None:
                return 'No user found!', 404 
            if  project.projectMembers == None:
                project.projectMembers = user.userID + ','
            else: project.projectMembers += user.userID + ','
            db.session.commit()

        elif args['updateCommand'] == 'projectRepoLink':
            project.projectRepoLink = args['projectRepoLink']
            db.session.commit()

        elif args['updateCommand'] == 'projectName':
            project.projectName = args['projectName']
            db.session.commit()

        elif args['updateCommand'] == 'projectDescription':
            project.projectDescription = args['projectDescription']
            db.session.commit()

        elif args['updateCommand'] == 'tasks':        
            if  project.projectTasks == None:
                project.projectTasks = args['projectTasks'] + SEPERATOR
            else: project.projectTasks += args['projectTasks'] + SEPERATOR
            db.session.commit()
        

        return project.toJSON()


    def delete(self):
        args = projectDetailsArgs.parse_args()

        currentProject = ProjectDetails.query.filter_by(projectID = args['projectID']).first()

        if 'memberDelete' in args['updateCommand']:
            listOfMembers = currentProject.projectMembers.split(',')

            if args['updateCommand'] == 'memberDelete_userID':
                if args['projectMembers'] in listOfMembers:
                    listOfMembers.remove(args['projectMembers'])
            elif args['updateCommand'] == 'memberDelete_username':
                try:
                    user = UserDetails.query.filter_by(username = args['projectMembers']).first()
                    if user.userID in listOfMembers:
                        listOfMembers.remove(user.userID)

                except:
                    return 'User not found', 404



            stringOfMembers = ''
            
            for member in listOfMembers:
                if member != '':
                    stringOfMembers += member + ','
            
            currentProject.projectMembers = stringOfMembers

            db.session.commit()

        elif args['updateCommand'] == 'chatDelete':
            listOfChats = currentProject.projectChatList.split(',')
            if args['projectChatList'] in listOfChats:
                listOfChats.remove(args['projectChatList'])
            else:
                return 'Chat not found', 404
            
            stringOfChats = ''

            for chat in listOfChats:
                if chat != '':
                    stringOfChats += chat + ','

            currentProject.projectChatList = stringOfChats

            db.session.commit()

        elif args['updateCommand'] == 'tasksDelete':
            listOfTasks = currentProject.projectTasks.split(SEPERATOR)
            print(listOfTasks)
            if args['projectTasks'] in listOfTasks:
                listOfTasks.remove(args['projectTasks'])
            else:
                return 'Task not found', 404
            
            stringOfTasks = ''

            for task in listOfTasks:
                if task != '':
                    stringOfTasks += task + SEPERATOR

            currentProject.projectTasks = stringOfTasks

            db.session.commit()

        elif args['updateCommand'] == 'deleteAllTasks':
            
            currentProject.projectTasks = ''

            db.session.commit()

        return currentProject.toJSON()       









api.add_resource(Projects, '/projectdetails')






















###################################################################################################################################################



class UserDetails(db.Model):
    userID = db.Column(db.String, primary_key = True, nullable = False)
    username = db.Column(db.String, unique = True,  nullable = False)
    password = db.Column(db.String, nullable = False)
    joinedOn = db.Column(db.String, nullable = False)
    projects = db.Column(db.String, nullable = False)

    def __repr__(self):
        return f'Username : {self.username}, Joined on : {self.joinedOn}'

    def toJSON(self):

        return {
            'userID': self.userID,
            'username': self.username,
            'joinedOn': self.joinedOn,
            'projects': self.projects,
        }





user_args = reqparse.RequestParser()
user_args.add_argument('username', type = str, help = 'No username was sent!')
user_args.add_argument('password', type = str, help = 'Password empty!')
user_args.add_argument('projects', type = str, help = 'Project empty!')
user_args.add_argument('userID', type = str, help = 'userID empty!')
user_args.add_argument('updateCommand', type = str, help = 'Update command not sent')





class User(Resource):

    def get(self):
        args = user_args.parse_args()
        user = UserDetails.query.filter_by(username = args['username']).first()
        if not user: #username doesnt exist
            abort(404, message = 'Username doesnt exist!')

        return user.toJSON()

        
    def post(self): #register/updater
        args = user_args.parse_args()
        print(args)

        if args['updateCommand'] == 'newUserRegister':
            joinedOn = datetime.now().strftime('%B %d, %Y %H:%M')
            userID = 'USER_ID_' + ''.join(random.choices(string.ascii_uppercase + string.digits, k = 15))
            
            new_user = UserDetails(username = args['username'], password = args['password'], joinedOn = joinedOn, userID = userID, projects = '')

            db.session.add(new_user)
            db.session.commit()

            return 'User created!', 200

        elif args['updateCommand'] == 'retrieveUserFromID':
            try:
                user = UserDetails.query.filter_by(userID = args['userID']).first()
                return user.toJSON()
            except:
                return 'User not found', 404

        elif args['updateCommand'] == 'retrieveUserFromUsername':
            try:
                user = UserDetails.query.filter_by(username = args['username']).first()
                return user.toJSON()
            except:
                return 'User not found', 404

        elif args['updateCommand'] == 'checkLike':
            users = UserDetails.query.filter(UserDetails.username.ilike(f"%{args['username']}%")).all()
            stringListofUsers = ''

            for user in users:
                stringListofUsers += user.username + ','
            
            if stringListofUsers == '' :
                return 'No matches', 404
            else:
                return {'matches' : stringListofUsers},  200

        elif args['updateCommand'] == 'usernameUpdate':
            checkUser = UserDetails.query.filter_by(username = args['username']).first()

            if checkUser:
                return 'Username taken', 409
            else:
                user = UserDetails.query.filter_by(userID = args['userID']).first()
                user.username = args['username']

                db.session.commit()

            return user.toJSON()

        elif args['updateCommand'] == 'passwordUpdate':
            user = UserDetails.query.filter_by(userID = args['userID']).first()
            user.password = args['password']

            db.session.commit()


            




    def options(self):
        print('Options handled!')
        return 200


    def put(self): #login
        args = user_args.parse_args()
        if not UserDetails.query.filter_by(username = args['username']).first(): #username doesnt exist
            abort(404, message = 'Username doesnt exist!')

        user = UserDetails.query.filter_by(username = args['username']).first()
        
        if user.password != args['password']:
            abort(401, message = 'Wrong Password!')

        return user.toJSON()

    def patch(self): #update projects
        args = user_args.parse_args()
        if not UserDetails.query.filter_by(username = args['username']).first(): #username doesnt exist
            abort(404, message = 'Username doesnt exist!')

        user = UserDetails.query.filter_by(username = args['username']).first()

        user.projects += args['projects'] + ','
        db.session.commit()

        return user.toJSON()


    def update(self): #update credentials
        args = user_args.parse_args()
        if not UserDetails.query.filter_by(username = args['username']).first(): #username doesnt exist
            abort(404, message = 'Username doesnt exist!')

        user = UserDetails.query.filter_by(username = args['username']).first()

        if args['username'] != None or args['username'] != '':
            user.username = args['username']

        if args['password'] != None or args['password'] != '':
            user.username = args['password']

        db.session.commit()

        return user.toJSON()



api.add_resource(User, '/user')


###################################################################################################################################################



if __name__ == '__main__':
    app.run(debug=True, host= '0.0.0.0')
