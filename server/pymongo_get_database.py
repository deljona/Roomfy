from pymongo import MongoClient

def get_database():
    
    # Connection string
    CONNECTION_STRING = "mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+1.8.0"
    
    # Create a connection
    client = MongoClient(CONNECTION_STRING)
    
    # Create a DataBase
    return client['usuarios_registrados']

if __name__=="__main__":
    
    # Get the database
    dbname = get_database()