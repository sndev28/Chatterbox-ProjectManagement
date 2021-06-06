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


app = Flask(__name__)
CORS(app)
api = Api(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///chatdatabase.db'
db = SQLAlchemy()
db.init_app(app)

with app.app_context():
    db.create_all()








# class UserProjectDetails(db.Model):
#     userID = db.Column(db.String, primary_key = True, nullable = False)
#     projects = db.Column(db.String)

#     def __repr__(self):
#         return {self.userID : self.projects}



# userProjectDetailsArgs = reqparse.RequestParser()
# userProjectDetailsArgs.add_argument('userID', type = str, help = 'userID not sent!')
# userProjectDetailsArgs.add_argument('projects', type = str, help = 'project IDs not sent!')


# class UserProject(Resource):
#     def get(self):
#         args = userProjectDetailsArgs.parse_args()
#         retrieved_user = UserProjectDetails.query.filter_by(userID = args['userID']).first()
#         if not retrieved_user:
#             return 'No such user exists!'

#         return retrieved_user.__repr__()


#     def put(self):
#         args = userProjectDetailsArgs.parse_args()
#         retrieved_user = UserProjectDetails.query.filter_by(userID = args['userID']).first()
#         if not retrieved_user:
#             new_user = UserProjectDetails(userID = args['userID'], projects = '')
#             db.session.add(new_user)
#             db.session.commit()

#             return 'New user created'
#         return 'User already exists'


#     def patch(self):
#         args = userProjectDetailsArgs.parse_args()
#         retrieved_user = UserProjectDetails.query.filter_by(userID = args['userID']).first()
#         if not retrieved_user:
#             return 'No such user exists!'

#         retrieved_user.projects += args['projects']
#         db.session.commit()
#         return 'Project list updated'



# api.add_resource(UserProject, '/userprojects')


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

    def toJSON(self):
        return {
            'projectID': self.projectID,
            'projectName': self.projectName,
            'projectCreatedOn': self.projectCreatedOn,
            'projectRepoLink': self.projectRepoLink,
            'projectAdmin': self.projectAdmin,
            'projectMembers': self.projectMembers,
            'projectDescription': self.projectDescription,
            'projectChatList': self.projectChatList
        }





projectDetailsArgs = reqparse.RequestParser()
projectDetailsArgs.add_argument('projectID', type = str, help = 'projectID not sent!')
projectDetailsArgs.add_argument('projectName', type = str, help = 'projectName not sent!')
projectDetailsArgs.add_argument('projectRepoLink', type = str, help = 'projectRepoLink not sent!')
projectDetailsArgs.add_argument('projectAdmin', type = str, help = 'projectAdmin not sent!')
projectDetailsArgs.add_argument('projectMembers', type = str, help = 'projectMembers not sent!')
projectDetailsArgs.add_argument('projectDescription', type = str, help = 'projectDescription not sent!')
projectDetailsArgs.add_argument('projectChatList', type = str, help = 'projectChatList not sent!')




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

    def patch(self): #update chatlist
        print(projectDetailsArgs.parse_args())
        args = projectDetailsArgs.parse_args()
        if not ProjectDetails.query.filter_by(projectID = args['projectID']).first(): #project doesnt exist
            print('Project doesnt exist!')
            abort(404, message = 'Project doesnt exist!')

        print('Project exists!')

        project = ProjectDetails.query.filter_by(projectID = args['projectID']).first()

        print('Project retrieved!')
        
        if  project.projectChatList == None:
            project.projectChatList = args['projectChatList'] + ','
        else: project.projectChatList += args['projectChatList'] + ','
        db.session.commit()

        return project.toJSON()








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
user_args.add_argument('username', type = str, help = 'No username was sent!', required = True)
user_args.add_argument('password', type = str, help = 'Password empty!', required = True)
user_args.add_argument('projects', type = str, help = 'Project empty!', required = False)





class User(Resource):

    def get(self):
        args = user_args.parse_args()
        user = UserDetails.query.filter_by(username = args['username']).first()
        if not user: #username doesnt exist
            abort(404, message = 'Username doesnt exist!')

        return user.toJSON()

        
    def post(self): #register/updater
        args = user_args.parse_args()
        user = UserDetails.query.filter_by(username = args['username']).first()
        if user: #username already taken
            return user.toJSON()

        joinedOn = datetime.now().strftime('%B %d, %Y %H:%M')
        userID = 'USER_ID_' + ''.join(random.choices(string.ascii_uppercase + string.digits, k = 15))
        
        new_user = UserDetails(username = args['username'], password = args['password'], joinedOn = joinedOn, userID = userID, projects = '')

        db.session.add(new_user)
        db.session.commit()

        return 'User created!', 200

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
