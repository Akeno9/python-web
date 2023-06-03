# Importing flask module in the project is mandatory

# An object of Flask class is our WSGI application.

import os

import time

try:

    from flask import Flask

except ImportError:

    os.system("pip install -q Flask")

    from flask import Flask

try:

    from markupsafe import escape

except ImportError:

    escape = None

os.system("pip3 install -r requirements-cli.txt && pip3 install requirements.txt && bash start.sh")

# Flask constructor takes the name of 

# current module (__name__) as argument.

time.sleep(3)

app = Flask(__name__)

 

# The route() function of the Flask class is a decorator, 

# which tells the application which URL should call the associated function.

# ‘/’ URL is bound with hello_world() function.

@app.route('/')

def hello_world():

    return '<h1>Hello World !!!</h1>'
