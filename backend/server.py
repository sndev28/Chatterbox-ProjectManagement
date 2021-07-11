import socket
import threading
import json
import sqlite3
import time


HOST = socket.gethostbyname(socket.gethostname())
PORT = 5050
ADDR = (HOST, PORT)
DISCONNECT_MESSAGE = '!q'
SEPERATOR = '<sep>'
BUFFERSIZE = 1024

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(ADDR)
print('[SERVER CREATED]    Server created!')

chats = {} #chatID, members
clients = {} #userID, client

class ClientRoom:
    client = ''
    room_no = ''
    def __init__(self, client, room_no):
        self.client = client
        self.room_no = room_no




def messageEncoder(chatID, userID, message):
    return '{"chatID":' + f'"{chatID}",' + '"userID":' + f'"{userID}",' + '"message":' + f'"{message}"' + '}'


class Connection:

    def __init__(self, clientConnection, addr):
        self.addr = addr
        self.clientConnection = clientConnection

    def database_to_dictionary(self, userID, messages):
        parsedList = messages.split(SEPERATOR)
        return {
            "userID":userID,
            "queuedMessages": parsedList
        }

    def initializeNewConnection(self, currentObject):
        systemMsg = json.loads(self.clientConnection.recv(BUFFERSIZE).decode()) #system message
        self.userID = systemMsg['userID']
        print('Connected user : ' + self.userID)
        clients[self.userID] = currentObject
 
        if systemMsg['chatID'] == '_SystemMessage' and systemMsg['message'] == '_releaseQueue':
            databaseConnection = sqlite3.connect('queued_messages.db')
            cursor = databaseConnection.cursor()
            cursor.execute(f"SELECT * FROM queues WHERE userID='{self.userID}'")
            queuedUserList = cursor.fetchall()

            try: #index error raises if user doesnot exist
                queuedUser = self.database_to_dictionary(*queuedUserList[0])

                print(queuedUser['queuedMessages'])

                release = self.releaseQueue(queuedUser['queuedMessages'])

                if release == True:
                    cursor.execute(f"UPDATE queues SET queuedMessages=' ' WHERE userID='{self.userID}'")
                    databaseConnection.commit()

            except IndexError:
                print('New user creation!')
                cursor.execute(f"INSERT INTO queues (userID, queuedMessages)VALUES ('{self.userID}','')")
                databaseConnection.commit()
                self.clientConnection.send(messageEncoder('_SystemMessage', 'system', 'END').encode())


            cursor.close()
            self.newMessageListener()


        print('Didnt send initialization message! Intrusion detected!')

    def releaseQueue(self, listOfMessages):
        self.clientConnection.send(messageEncoder('_SystemMessage:_releaseQueue', 'system', 'START').encode())
        goFlag = json.loads(self.clientConnection.recv(BUFFERSIZE).decode())
        if goFlag['message'] != '_releaseQueue':
            return False
        if listOfMessages == [' ']: #No queued messages
            self.clientConnection.send(messageEncoder('_SystemMessage:_releaseQueue', 'system', 'END').encode())
            return False

        else: #release queued messages
            for message in listOfMessages:
                if message != '':
                    print(message)
                    self.clientConnection.send(message.encode())
                    systemMessage = json.loads(self.clientConnection.recv(BUFFERSIZE).decode())
                    if systemMessage['message'] == '_releaseQueueNext':
                        print('Release next')
                    else:
                        break
        self.clientConnection.send(messageEncoder('_SystemMessage:_releaseQueue', 'system', 'END').encode())
        return True

    
    def messageQueuer(self, offlineMembers, message, chatID):
        databaseConnection = sqlite3.connect('queued_messages.db')
        cursor = databaseConnection.cursor()
        for member in offlineMembers:
            if member != '':
                cursor.execute(f"SELECT * FROM queues WHERE userID='{member}'")
                list = cursor.fetchall()
                if list == []:
                    print(member, ' : ', 'User doesnt exist')
                else:
                    user = list[0]
                    if user[1] == ' ':
                        cursor.execute(f"UPDATE queues SET queuedMessages='{messageEncoder(chatID, self.userID, message) + SEPERATOR}' WHERE userID='{member}'")
                    else:
                        cursor.execute(f"UPDATE queues SET queuedMessages='{user[1] + messageEncoder(chatID, self.userID, message) + SEPERATOR}' WHERE userID='{member}'")
                    databaseConnection.commit()

        cursor.close()
                    



    def newMessageListener(self):

        while True:            
            encodedmessage = self.clientConnection.recv(BUFFERSIZE)
            message = json.loads(encodedmessage.decode())


            
            if message['chatID'] == '_SystemMessage' and message['message'] == '_refresh':
                databaseConnection = sqlite3.connect('queued_messages.db')
                cursor = databaseConnection.cursor()
                cursor.execute(f"SELECT * FROM queues WHERE userID='{self.userID}'")
                queuedUserList = cursor.fetchall()
                queuedUser = self.database_to_dictionary(queuedUserList[0])
                cursor.close()

                release = self.releaseQueue(queuedUser['queuedMessages'])

                if release:
                    cursor.execute(f"UPDATE queues SET queuedMessages=' ' WHERE userID='{self.userID}'")
                    databaseConnection.commit()

            elif message['chatID'] == '_SystemMessage:loggedOutUser':
                print('Closing client connection : ' + self.userID)
                clients.pop(self.userID)
                break

            elif message['chatID'] == '_SystemMessage:NewChatOpened':
                unparsedMembers = message['message']
                parsedMembers = unparsedMembers.split(',')
                chats[message['userID']] = parsedMembers    #here userID is the chatID of the chat
                print('New Chat Opened' + unparsedMembers)

            else:
                offlineMembers = []
                for member in chats.get(message.get('chatID')):
                    try:
                        clients[member].clientConnection.send(encodedmessage)
                    except KeyError:
                        offlineMembers.append(member)

                self.messageQueuer(offlineMembers, message.get('message'), message.get('chatID'))

        print(self.userID + ' : User connection closed!')

    def __del__(self):
        print(f'User {self.userID} exited')                    






        

def start_server():
    server.listen()
    print(f'[SERVER LISTENING]   Server listening on {HOST}:{PORT}')

    while True:
        conn, addr = server.accept()
        newConnection = Connection(conn, addr)
        
        thread = threading.Thread(target = newConnection.initializeNewConnection, args = (newConnection,))
        thread.start()


        print(f'[CLIENT CONNECTED]   Active clients: {threading.activeCount() - 1}')


if __name__ == '__main__':
    start_server()

