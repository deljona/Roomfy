import base64
import json
from flask import Flask, render_template
from flask_socketio import SocketIO
from cryptography.fernet import Fernet
from pymongo_get_database import get_database


dbname = get_database()
collection_usuarios = dbname["usuarios"]
collection_mensajes = dbname["mensajes"]

key = Fernet.generate_key()
__SECRET_KEY = base64.urlsafe_b64encode(key).decode()

app = Flask(__name__)
app.config['SECRET_KEY'] = __SECRET_KEY
socketio = SocketIO(app)


@socketio.on('registro')
def handle_new_user(new_user):
    # Decodificar JSON
    nuevo_usuario = json.loads(new_user)

    # Asignar campos a variables
    nombre = str(nuevo_usuario['name'])
    usuario = str(nuevo_usuario['username'])

    # Verificar si el usuario ya existe
    usuario_existente = collection_usuarios.find_one(nuevo_usuario)

    if usuario_existente:
        print('El usuario ya existe en la colección')
    else:
        print('El usuario no existe en la colección')
        results = collection_usuarios.insert_one(nuevo_usuario)
        print(results.inserted_id)


if __name__ == '__main__':
    socketio.run(app, debug=True)
