from flask import Flask, render_template
from flask_socketio import SocketIO
from cryptography.fernet import Fernet
import base64

key = Fernet.generate_key()
__SECRET_KEY = base64.urlsafe_b64encode(key).decode()

app = Flask(__name__)
app.config['SECRET_KEY'] = __SECRET_KEY
socketio = SocketIO(app)

# @socketio.on('mensaje')
# def handle_message(mensaje):
#     print(mensaje)

if __name__ == '__main__':
    socketio.run(app, debug=True)