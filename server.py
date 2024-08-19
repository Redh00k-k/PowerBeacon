import argparse
import shutil
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

class MyHTTPRequestHandler(BaseHTTPRequestHandler):
    def _set_headers(self, code):
        self.send_response(code)
        self.send_header('Content-type', 'text/application')
        self.end_headers()

    def do_GET(self):
        path = os.path.join(os.getcwd(), self.path.strip('/'))
        if os.path.isdir(path):
            self.list_directory(path)
            return
        if not os.path.isfile(path):
            self._set_headers(404)
            return
        with open(path, "rb") as f:
            self._set_headers(200)
            shutil.copyfileobj(f, self.wfile)

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        self._set_headers(200)
        print(post_data.decode('UTF-8'))

def main():
    parser = argparse.ArgumentParser(
        description="beacon server."
    )
    parser.add_argument('-i', '--interface', type=str, nargs="?", default="127.0.0.1", help="Set IP address")
    parser.add_argument('-p', '--port', type=int, nargs="?", default="8888", help="Port number")
    parser.add_argument('-v', '--verbose', action='store_true')
    args = parser.parse_args()

    print("Serving HTTP on :: port {} ...".format(args.port))
    server_address = ('', args.port)
    httpd = HTTPServer(server_address, MyHTTPRequestHandler)
    try: 
        httpd.serve_forever()
    except KeyboardInterrupt:
        return

if __name__=='__main__':
    main()