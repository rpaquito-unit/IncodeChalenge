from flask import Flask, request
import json

app = Flask(__name__)

@app.route('/')
def home():
    return "Backend Works!!!"


@app.route('/api/name', methods=['GET'])
def get_names():
    return "Get names Works!!!"

@app.route('/api/city', methods=['GET'])
def get_city():
    return "Get city Works!!!"