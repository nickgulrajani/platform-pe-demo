from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/health")
def health():
    return jsonify(status="ok")

@app.route("/")
def index():
    return jsonify(message="Hello from the Platform Engineering demo on port 5000!")

if __name__ == "__main__":
    # Bind to 0.0.0.0 so Kubernetes can route traffic
    app.run(host="0.0.0.0", port=5000)
