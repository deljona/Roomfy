from pymongo_get_database import get_database
from flask import Flask, render_template
from flask_socketio import SocketIO
from cryptography.fernet import Fernet
import base64

dbname = get_database()
collection_usuarios = dbname["usuarios"]

key = Fernet.generate_key()
__SECRET_KEY = base64.urlsafe_b64encode(key).decode()

app = Flask(__name__)
app.config['SECRET_KEY'] = __SECRET_KEY
socketio = SocketIO(app)

@socketio.on('registro')
def handle_new_user(new_user):
    nombre = str(new_user['name'])
    usuario = str(new_user['username'])
    cursor = collection_usuarios.find()
    for user in cursor:
        nombre_registrado = str(user['name'])
        usuario_registrado = str(user['username'])
        if(nombre.__eq__(nombre_registrado) and usuario.__eq__(usuario_registrado)):
            print("No registrar usuario")
            break
    else:
        collection_usuarios.insert_one(new_user)
    
if __name__ == '__main__':
    socketio.run(app, debug=True)