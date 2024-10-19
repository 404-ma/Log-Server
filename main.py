import re
from flask import Flask, render_template, request
from flask_cors import CORS
import os
from read import output

app = Flask(__name__)
CORS(app)

global_state = {"out": ""}


@app.route("/clear")
def clear():
    global global_state
    global_state["out"] = ""
    return "cleared"


@app.route("/view")
def view():
    return render_template("result.html", result=global_state["out"])


@app.route("/")
def index():
    return render_template("./index.html")


@app.route("/upload", methods=["POST"])
def upload_file():
    if "file" not in request.files:
        return "No file part", 400

    file = request.files["file"]

    if file.filename == "":
        return "No selected file", 400

    result = ""

    if file:
        result = output(file)

    global global_state
    global_state["out"] = global_state["out"] + result

    return render_template("result.html", result=global_state["out"])


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=1000, debug=True)
