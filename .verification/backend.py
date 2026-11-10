import json
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
root = Path(__file__).resolve().parent
mode = (root / "mode").read_text().strip()
class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200); self.end_headers(); self.wfile.write(b"ok")
    def do_POST(self):
        self.rfile.read(int(self.headers.get("Content-Length", 0)))
        path = self.path
        if path.endswith("/libraries/tests/services/setting"):
            data = json.loads((root / "settings.json").read_text())
        elif path.endswith("/ci/tests/skippable"):
            data = json.loads((root / "skippable.json").read_text()) if mode.startswith("empty") else {"data": [], "meta": {"correlation_id": "verification"}}
        elif path.endswith("/ci/ddtest/test_suite_durations"):
            data = json.loads((root / "durations.json").read_text())
        elif path.endswith("/git/repository/search_commits"):
            data = {"data": []}
        else:
            data = {}
        body = json.dumps(data).encode()
        self.send_response(200); self.send_header("Content-Type", "application/json"); self.send_header("Content-Length", str(len(body))); self.end_headers(); self.wfile.write(body)
ThreadingHTTPServer(("127.0.0.1", 5267), Handler).serve_forever()
