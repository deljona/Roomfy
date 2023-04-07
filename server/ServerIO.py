from flask import Flask, render_template
from flask_socketio import SocketIO
from cryptography.fernet import Fernet
import base64

key = Fernet.generate_key()
__SECRET_KEY = base64.urlsafe_b64encode(key).decode()

app = Flask(__name__)
app.config['SECRET_KEY'] = __SECRET_KEY
socketio = SocketIO(app)

@socketio.on('registro')
def handle_new_user(usuario):
    # Comprobar que el usuario no existe
        # Si no existe registrarlo en MongoDB
    # Si existe
        # Emitir un mensaje de usuario existente
    print(usuario)

if __name__ == '__main__':
    socketio.run(app, debug=True)