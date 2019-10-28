#!/usr/bin/python

from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer

import re
import sys

URL = sys.argv[1]
PORT_NUMBER = int(re.search('localhost:(.*?)/', URL).group(1))
flag = True

class requestHandler(BaseHTTPRequestHandler):
	def do_GET(self):
		global flag

		if flag:
			flag = False

			if "code=" in self.path:
				self.send_response(200)
				self.send_header('Content-type','text/html')
				self.end_headers()
				self.wfile.write("Success!")

				# return code
				print re.search('code=(.*?)(&|$)', self.path).group(1)
			else:
				print "error"

			# shutdown the server
			import threading
			assassin = threading.Thread(target=server.shutdown)
			assassin.daemon = True
			assassin.start()

try:
	server = HTTPServer(('', PORT_NUMBER), requestHandler)
	server.serve_forever()

except KeyboardInterrupt:
	print '^C received, shutting down the web server'
	server.socket.close()


