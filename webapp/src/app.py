from flask import Flask, render_template, request, url_for, flash, redirect
import os

app = Flask(__name__)

@app.route("/hello")
def hello():
    return "Hello World!"


@app.route("/")
def index():

    if os.environ['backendDns']:
        backendURL = os.environ['backendDns']
    else:
        backendURL = "http://localhost:5001"

    links = {backendURL+"/api/name" : 'Get Names', backendURL+"/api/city": 'Get Cities'}
    returnVal = ""

    for link in links:
            returnVal+= "<a href=\""+link+"\"<h2>"+links[link]+"</h2></a></hr><br>"

    #return render_template('index.html', links=links)
    return returnVal  
