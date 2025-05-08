from flask import Flask, jsonify, request




app = Flask(__name__)
#creamos nuestro primer endpoint
@app.route("/")
def root():
    return "IoT Server"

#Método GET
@app.route("/users/<user_id>") # <> entrega parámetros mediante URL
def get_user(user_id):
    user = {"id": user_id, "name": "test_ueser", "telefono": "999-666"}
    
    query = request.args.get("query") #Consulta.argumentos.obtener(lokquiereobtener)
    if query:  #Veryfica si existe este query y si hay crea el campo query con valor de la consulta
        user["query"] = query
    return jsonify(user), 200


@app.route('/users', methods = ['POST'])
def create_user():
    data = request.get_json()
    data["status"] = "user created"
    return jsonify(data), 201




if __name__ == '__main__':
    app.run(debug = True)


## /users/2654?query=query_test

# Hasta ahora retornamos solo código, no hay base de datos