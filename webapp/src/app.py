from flask import Flask, render_template, request, url_for, flash, redirect
import os
import requests

app = Flask(__name__)

@app.route("/hello")
def hello():
    return "Hello World!"


@app.route("/")
def index():

    if os.getenv('backendDns') is not None:
        backendURL = os.environ['backendDns']
    else:
        backendURL = "localhost:5001"

    links = {"http://"+backendURL+"/api/name" : 'Get Names', "http://"+backendURL+"/api/city": 'Get Cities'}
    returnVal = ""

    for link in links:
            returnVal+= "<a href=\""+link+"\"<h2>"+links[link]+"</h2></a></hr><br>"

    return returnVal  

@app.route("/names")
def names():

    if os.getenv('backendDns') is not None:
        backendURL = os.environ['backendDns']
    else:
        backendURL = "localhost:8081"

    api_url = "http://"+backendURL+"/api/name"    
    response = requests.get(api_url, timeout=10)
 
    return response.content

@app.route("/cities")
def cities():

    if os.getenv('backendDns') is not None:
        backendURL = os.environ['backendDns']
    else:
        backendURL = "localhost:8081"

    api_url = "http://"+backendURL+"/api/city"    
    response = requests.get(api_url, timeout=10)
 
    return response.content
