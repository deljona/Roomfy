class RSA:
    def __init__(self):
        # Generar claves públicas y privadas
        (self.public_key, self.private_key) = rsa.newkeys(512)

    def encrypt(self, message):
        # Codificar la cadena a una cadena de bytes
        message = message.encode('utf8')

        # Encriptar la cadena de bytes con la clave pública
        crypto = rsa.encrypt(message, self.public_key)

        return crypto

    def decrypt(self, crypto):
        # Desencriptar la cadena de bytes con la clave privada
        message = rsa.decrypt(crypto, self.private_key)

        # Decodificar la cadena de bytes a una cadena
        message = message.decode('utf8')

        return message
    
if __name__=="__main__":
    rsa = RSA()