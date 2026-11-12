import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

# APP_VERSION is baked into the image so a new tag is visible.
# TENANT is injected by the chart and stays put across that bump.


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        body = f"{os.environ['TENANT']} {os.environ['APP_VERSION']}\n".encode()
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        return


if __name__ == "__main__":
    ThreadingHTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
