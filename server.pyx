import re
from flask import Flask, render_template, request, jsonify
from flask_cors import CORS
import os

# imports from the compiled c module
from read import output

os.environ["FLASK_ENV"] = "production"

app = Flask(__name__)
CORS(app)

global_state = {"out": "", "files": [], "fileName": ""}


@app.route("/getfilename")
def getFileName():
    global global_state
    return jsonify(global_state["fileName"])


@app.route("/browse")
def browse():
    global global_state
    return render_template(
        "browse.html", files=global_state["files"], fileName=global_state["fileName"]
    )


@app.route("/choosefile", methods=["POST"])
def choosefile():
    if not request.is_json:
        print("invalid json")
        return "Invalid JSON", 400

    data = request.get_json()

    global global_state
    global_state["fileName"] = data["fileName"]

    return jsonify({"data": "success"}), 201


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


@app.route("/updatefiles", methods=["POST"])
def updateFiles():
    if not request.is_json:
        print("invalid json")
        return "Invalid JSON", 400

    data = request.get_json()

    if (
        not isinstance(data, dict)
        or "files" not in data
        or not isinstance(data["files"], list)
    ):
        return "No valid 'files' key found", 400

    files = data["files"]
    print("FILES: ", files)

    global global_state

    global_state["files"] = files

    print(global_state["files"])

    return "success"


@app.route("/upload", methods=["POST"])
def upload_file():
    if "file" not in request.files:
        return "No file part", 400

    file = request.files["file"]

    if file.filename == "":
        return "No selected file", 400

    result = ""

    if file:
        result = f"\nFILENAME: {file.filename}\n\n"
        result += output(file)

    global global_state
    global_state["out"] = global_state["out"] + result

    # return render_template("result.html", result=global_state["out"])
    return render_template("redir.html")


