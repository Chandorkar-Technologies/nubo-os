#!/usr/bin/env python3
"""Minimal fake Nubo server for testing the GOA provider: IMAPS 993, SMTPS 465,
HTTPS 443 (OPTIONS with Basic auth) on one address. Needs root for low ports.
Password is read from /tmp/goatest/password on every attempt."""
import base64, socketserver, ssl, sys, threading, http.server, time

HOST = sys.argv[1] if len(sys.argv) > 1 else "127.0.0.2"
CERT, KEY = "/tmp/goatest/cert.pem", "/tmp/goatest/key.pem"
USER = "alice@nubo.test"
LOG = open("/tmp/goatest/server.log", "a", buffering=1)

def password():
    return open("/tmp/goatest/password").read().strip()

def log(*a):
    LOG.write(time.strftime("%H:%M:%S ") + " ".join(str(x) for x in a) + "\n")

ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
ctx.load_cert_chain(CERT, KEY)

class TLSTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    allow_reuse_address = True
    daemon_threads = True
    def get_request(self):
        sock, addr = super().get_request()
        try:
            return ctx.wrap_socket(sock, server_side=True), addr
        except Exception as e:
            log("tls handshake failed", e)
            sock.close()
            raise

class Imap(socketserver.StreamRequestHandler):
    def handle(self):
        self.wfile.write(b"* OK IMAP4rev1 fake nubo ready\r\n")
        for raw in self.rfile:
            line = raw.decode(errors="replace").strip()
            if not line:
                continue
            tag, _, rest = line.partition(" ")
            cmd = rest.split(" ")[0].upper()
            log("IMAP <", tag, cmd)
            if cmd == "CAPABILITY":
                self.wfile.write(b"* CAPABILITY IMAP4rev1\r\n%s OK done\r\n" % tag.encode())
            elif cmd == "LOGIN":
                parts = rest.split(" ", 2)
                u = parts[1].strip('"'); p = parts[2].strip('"') if len(parts) > 2 else ""
                if u == USER and p == password():
                    self.wfile.write(b"%s OK LOGIN completed\r\n" % tag.encode())
                else:
                    self.wfile.write(b"%s NO [AUTHENTICATIONFAILED] bad credentials\r\n" % tag.encode())
            elif cmd == "LOGOUT":
                self.wfile.write(b"* BYE bye\r\n%s OK done\r\n" % tag.encode())
                return
            else:
                self.wfile.write(b"%s OK\r\n" % tag.encode())

class Smtp(socketserver.StreamRequestHandler):
    def handle(self):
        self.wfile.write(b"220 fake.nubo ESMTP\r\n")
        for raw in self.rfile:
            line = raw.decode(errors="replace").strip()
            up = line.upper()
            log("SMTP <", line.split(" ")[0].upper(), (up.split(" ")[1] if up.startswith("AUTH") else ""))
            if up.startswith("EHLO"):
                self.wfile.write(b"250-fake.nubo\r\n250 AUTH PLAIN LOGIN\r\n")
            elif up.startswith("AUTH PLAIN"):
                blob = base64.b64decode(line.split(" ", 2)[2])
                _, u, p = blob.decode().split("\0")
                if u == USER and p == password():
                    self.wfile.write(b"235 2.7.0 ok\r\n")
                else:
                    self.wfile.write(b"535 5.7.8 bad credentials\r\n")
            elif up.startswith("QUIT"):
                self.wfile.write(b"221 bye\r\n")
                return
            else:
                self.wfile.write(b"250 ok\r\n")

class Dav(http.server.BaseHTTPRequestHandler):
    def log_message(self, fmt, *a):
        log("HTTP", self.command, self.path, "->", fmt % a)
    def do_OPTIONS(self):
        auth = self.headers.get("Authorization", "")
        ok = False
        if auth.startswith("Basic "):
            u, _, p = base64.b64decode(auth[6:]).decode().partition(":")
            ok = (u == USER and p == password())
        if not ok:
            self.send_response(401)
            self.send_header("WWW-Authenticate", 'Basic realm="fake"')
            self.send_header("Content-Length", "0")
            self.end_headers()
            return
        self.send_response(200)
        self.send_header("DAV", "1, 2, 3, calendar-access, addressbook")
        self.send_header("Allow", "OPTIONS, PROPFIND, GET")
        self.send_header("Content-Length", "0")
        self.end_headers()

class HTTPS(http.server.ThreadingHTTPServer):
    allow_reuse_address = True
    def get_request(self):
        sock, addr = super().get_request()
        return ctx.wrap_socket(sock, server_side=True), addr

servers = [TLSTCPServer((HOST, 993), Imap), TLSTCPServer((HOST, 465), Smtp), HTTPS((HOST, 443), Dav)]
for s in servers:
    threading.Thread(target=s.serve_forever, daemon=True).start()
log("fake server up on", HOST)
print("up", flush=True)
while True:
    time.sleep(3600)
