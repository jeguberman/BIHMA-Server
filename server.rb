require 'socket'
require 'uri'
require 'byebug'
require 'colorize'
require 'timeout'


require_relative 'util.rb'


begin #handle interrupt


WEB_ROOT = './public'

CONTENT_TYPE_MAPPING = {
  'html' => "text/html",
  "txt" => 'text/plain',
  'png' => 'image/png',
  'jpg' => 'image/jpeg'
}

PORT = 2345

HOST = IPSocket.getaddress(Socket.gethostname)


DEFAULT_CONTENT_TYPE = 'application/octet-stream'

server = TCPServer.new(HOST, PORT)

sputs "Starting Server 2, Listening on port #{PORT}", "green"

lock = Mutex.new

loop {
  Thread.start(server.accept) do |socket|
    lock.synchronize{
    add_thread_id


      sputs "_____________________________________","green"
      sputs "opening socket connection with client","green"

      sputs 'preparing to receive request line', "yellow" #for debugging
      request_line = socket.gets
      sputs 'received request line: ', "green" #for debugging
      sputs request_line

      path = get_requested_file(request_line)
      + path = File.join(path, 'index.html') if File.directory?(path)


      if File.exist?(path) && !File.directory?(path)

        File.open(path, "rb") do |file|
          socket.print "HTTP/1.1 200 OK\r\n" +
          "Content-Type: #{content_type(file)}\r\n" +
          "Content-Length: #{file.size}\r\n" +
          "Connection: close\r\n"

          socket.print "\r\n"

          IO.copy_stream(file, socket)
        end

      else
        message = "File not found\n"
        # respond with a 404 error code to indicate the file does not exist
        File.open("public/no_match.html") do |file|
          socket.print "HTTP/1.1 404 Not Found\r\n" +
          "Content-Type: text/html\r\n" +
          "Content-Length: #{file.size}\r\n" +
          "Connection: close\r\n"

          socket.print "\r\n"
          IO.copy_stream(file, socket)
        end



      end
      sputs "closing socket connection with client", "green"
      sputs "_____________________________________", "green"
      sputs "*************************************", "blue"
      sputs "\r\n"
      socket.close

      remove_thread_id
      if Thread.list.length > 2
        sputs "Threads: #{Thread.list.length}", "magenta"
      end
    }
  end
}

rescue Interrupt => e
  onInterrupt
end
