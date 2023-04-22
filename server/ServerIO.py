import base64
import json
import logging

from flask import Flask, render_template
from flask_socketio import SocketIO
from cryptography.fernet import Fernet

from pymongo_get_database import get_database

logging.basicConfig(level=logging.DEBUG)

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

    # Verificar si el usuario ya existe
    usuario_existente = collection_usuarios.find_one(nuevo_usuario)

    if not usuario_existente:

        results = collection_usuarios.insert_one(nuevo_usuario)

        if results.acknowledged:
            logging.info(f'Se ha registrado un nuevo usuario: {nuevo_usuario}')
            socketio.emit('registrado', 0)
    else:
        logging.info(f'Ya esta registrado este usuario: {nuevo_usuario}')
        socketio.emit('registrado', 1)


if __name__ == '__main__':
    logging.info('=== Debug Start ===')
    socketio.run(app, debug=True)
