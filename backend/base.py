from flask import Flask
from flask_restful import Api, Resource

app = Flask(__name__)
api = Api(app)


class Home(Resource):
    def get(self):
        return 'Damn'



api.add_resource(Home, '/')


if __name__ == '__main__':
    app.run(debug=True)
