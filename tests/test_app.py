# tests/test_app.py
from app.app import app

def test_health_route_status_code():
    """Smoke test: /health should return HTTP 200."""
    client = app.test_client()
    resp = client.get("/health")
    assert resp.status_code == 200

def test_health_route_payload():
    """Smoke test: /health JSON payload should contain status=ok."""
    client = app.test_client()
    resp = client.get("/health")
    data = resp.get_json()
    assert data == {"status": "ok"}

