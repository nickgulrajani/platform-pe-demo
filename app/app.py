from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/health")
def health():
    return jsonify(status="ok")

@app.route("/")
def index():
    return jsonify(message="Hello from the Platform Engineering demo on port 5000!")

if __name__ == "__main__":
    # In Kubernetes, binding to 0.0.0.0 is required so the Service can route traffic.
    # We explicitly suppress Bandit B104 here while keeping the rest of SAST active.
    app.run(host="0.0.0.0", port=5000)  # nosec B104
