import json
import logging

from flask import Flask, render_template
from flask_socketio import SocketIO
import rsa

from pymongo_get_database import get_database

logging.basicConfig(level=logging.DEBUG)

dbname = get_database()
collection_usuarios = dbname["usuarios"]
collection_mensajes = dbname["mensajes"]

app = Flask(__name__)
app.config['SECRET_KEY'] = 'R3BRb3pqRm9QZ1'
socketio = SocketIO(app)

# Generar claves públicas y privadas
(public_key, private_key) = rsa.newkeys(512)

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


@socketio.on('login')
def login(user):
    # Decodificar JSON
    usuario_registrado = json.loads(user)

    # Verificar si el usuario está en la BBDD
    usuario_existe = collection_usuarios.find_one(usuario_registrado)

    if usuario_existe:
        logging.info(f'Inicio de sesión: {usuario_registrado}')
        socketio.emit('logeado', 0)
    else:
        logging.info(f'Error de login: {usuario_registrado}')
        socketio.emit('logeado', 1)


@socketio.on('getMsgFromDb')
def getMessagesFromMongoDB():
    data = []
    for msg in collection_mensajes.find({}, {'message': 1, 'senderUsername': 1, '_id': 0}):
        logging.info(msg['message'])
        # data.append(msg)

    socketio.emit('getMsgs', data)
    logging.info(data)


@socketio.on('message')
def listen_message(message):
    # Decodificar JSON
    new_message = json.loads(message)
    logging.debug(new_message)

    # Enviar respuesta al cliente
    socketio.emit('responseMessage', new_message)

    mensaje = str(new_message['message'])
    
    # Codificar la cadena a una cadena de bytes
    message = mensaje.encode('utf8')

    # Encriptar la cadena de bytes con la clave pública
    crypto = rsa.encrypt(message, public_key)

    new_message['message'] = crypto

    collection_mensajes.insert_one(new_message)


if __name__ == '__main__':
    logging.info('=== Debug Start ===')
    socketio.run(app, debug=True)
