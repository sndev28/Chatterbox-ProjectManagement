from hashlib import new
from flask import Flask
from flask_restful import Api, Resource, reqparse, abort
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime
import random
import string


app = Flask(__name__)
CORS(app)
api = Api(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///chatdatabase.db'
db = SQLAlchemy()
db.init_app(app)

with app.app_context():
    db.create_all()
















class ProjectDetails(db.Model):
    projectID = db.Column(db.String, primary_key = True, nullable = False)
    projectName = db.Column(db.String, nullable = False)
    projectCreatedOn = db.Column(db.String, nullable = False)
    projectRepoLink = db.Column(db.String)
    projectAdmin = db.Column(db.String, nullable = False)
    projectMembers = db.Column(db.String)
    projectDescription = db.Column(db.String)

    def toJSON(self):
        return {
            'projectID': self.projectID,
            'projectName': self.projectName,
            'projectCreatedOn': self.projectCreatedOn,
            'projectRepoLink': self.projectRepoLink,
            'projectAdmin': self.projectAdmin,
            'projectMembers': self.projectMembers,
            'projectDescription': self.projectDescription
        }





projectDetailsArgs = reqparse.RequestParser()
projectDetailsArgs.add_argument('projectID', type = str, help = 'projectID not sent!')
projectDetailsArgs.add_argument('projectName', type = str, help = 'projectName not sent!')
projectDetailsArgs.add_argument('projectRepoLink', type = str, help = 'projectRepoLink not sent!')
projectDetailsArgs.add_argument('projectAdmin', type = str, help = 'projectAdmin not sent!')
projectDetailsArgs.add_argument('projectMembers', type = str, help = 'projectMembers not sent!')
projectDetailsArgs.add_argument('projectDescription', type = str, help = 'projectDescription not sent!')




class Projects(Resource):

    def put(self): #newproject
        args = projectDetailsArgs.parse_args()
        projectCreatedOn = datetime.now().strftime('%B %d, %Y %H:%M')
        projectID = 'PR_ID_' + ''.join(random.choices(string.ascii_uppercase + string.digits, k = 15))
        newProject = ProjectDetails(**args, projectID = projectID, projectCreatedOn = projectCreatedOn)

        db.session.add(newProject)
        db.session.commit()

        return 'Project created!', 200

    def get(self): # retrieve page
        args = projectDetailsArgs.parse_args()
        print(args)

        retrieved_project = ProjectDetails.query.filter_by(projectID = args['projectID']).first()

        if not retrieved_project:
            abort(404, 'Given project not found')

        return retrieved_project.toJSON(), 200






api.add_resource(Projects, '/projectdetails')






















###################################################################################################################################################



class UserDetails(db.Model):
    user_id = db.Column(db.String, primary_key = True, nullable = False)
    username = db.Column(db.String, unique = True,  nullable = False)
    password = db.Column(db.String, nullable = False)
    joined_on = db.Column(db.String, nullable = False)

    def __repr__(self):
        return f'Username : {self.username}, Joined on : {self.joined_on}'





user_args = reqparse.RequestParser()
user_args.add_argument('username', type = str, help = 'No username was sent!', required = True)
user_args.add_argument('password', type = str, help = 'Password empty!', required = True)





class User(Resource):

    def post(self): #register
        args = user_args.parse_args()
        print(args)
        if UserDetails.query.filter_by(username = args['username']).first(): #username already taken
            abort(409, message = 'Username already exists!')

        joined_on = datetime.now().strftime('%B %d, %Y %H:%M')
        user_id = 'USER_ID_' + ''.join(random.choices(string.ascii_uppercase + string.digits, k = 15))
        
        new_user = UserDetails(username = args['username'], password = args['password'], joined_on = joined_on, user_id = user_id)

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

        return {'user_id':user.user_id, 'joined_on': user.joined_on}



api.add_resource(User, '/user')


###################################################################################################################################################



if __name__ == '__main__':
    app.run(debug=True, host= '0.0.0.0')
