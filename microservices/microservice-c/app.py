from flask import Flask

app = Flask(__name__)

# Define the version and service name
version = "v2"
service_name = "Microservice C"

@app.route('/')
def home():
    return f"{service_name} {version}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)
