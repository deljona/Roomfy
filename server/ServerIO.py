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
    nombre = nuevo_usuario['name']
    usuario = nuevo_usuario['username']

    # Crear cursor
    cursor = collection_usuarios.find()

    # Comprobar disponibilidad
    for user in cursor:
        nombre_registrado = user['name']
        usuario_registrado = user['username']
        if (nombre.__eq__(nombre_registrado) and usuario.__eq__(usuario_registrado)):
            print(f"Ya existe el usuario: {nuevo_usuario}")
            socketio.emit('registrado', 0)
            break
    else:
        collection_usuarios.insert_one(nuevo_usuario)
        socketio.emit('registrado', 1)
        print(f"Nuevo usuario registrado: {nuevo_usuario}")


if __name__ == '__main__':
    socketio.run(app, debug=True)
