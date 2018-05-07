require 'socket'
require 'byebug'

# HOST = "192.168.1.170"
HOST = "localhost"
PORT = 2345
def eputs(string)
  STDERR.puts(string, "\r\n")
end
eputs "testing... : #{TCPSocket.gethostbyname("localhost")}"
server = TCPServer.new(HOST, 2345)
eputs("starting server 1, listening on port 2345")
loop do

  Thread.start(socket = server.accept) do |socket|
    eputs("Client connected, reading request")



    request = socket.gets
    eputs("request received...")
    STDERR.puts request

    response = "hullo\r\n"
    eputs("sending response")
    socket.print "http/1.1 200 OK\r\n"
    "Content-Type: text/plain\r\n"+
    "Content-Length:#{response.bytesize}\r\n"+
    "Connection: close\r\n"

    socket.print "\r\n"

    socket.print response
    eputs("response sent, closing connection")
    socket.close
    eputs("connection closed")

    eputs("______________________________")
    eputs("\r\n")
  end
end
