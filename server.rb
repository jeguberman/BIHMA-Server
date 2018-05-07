#!/usr/bin/env ruby

require 'socket'
require 'uri'
require 'byebug'
require 'colorize'
require 'timeout'

require_relative './globals.rb'
require_relative './util/util.rb'

begin #handle interrupt
WEB_ROOT = './public'
PORT = 2345
HOST = IPSocket.getaddress(Socket.gethostname)

server = TCPServer.new(HOST, PORT)

sputs "Starting Server 2 on host #{Socket.gethostname}(#{HOST}); Listening on port #{PORT}", color: "green", important: true

lock = Mutex.new #prevent different threads from accessing or mtuating the same variables


loop {
  Thread.start(server.accept) do |socket|
    lock.synchronize{

      add_thread_id
      sputs "_____________________________________", color: "green"

      sputs "opening socket connection with client from #{socket.remote_address.ip_address}", color: "green", important: true


      sputs 'preparing to receive request line', color: "yellow"

      # request_line = socket.gets

      #PARSE REQUEST
      request_line_status, request_line = getRequestWithTimeout(socket)
      sputs request_line_status, important: true
      sputs request_line, important:true, indent:true

      #DETERMINE PATH
      path = get_file_path(request_line)
      path = path + "/index.html" if File.directory?(path)

      #SEND RESPONSE
      sputs "rendering response", color: "yellow"
      response, fileBuffer = renderResponse(path)

      socket.print(response)
      socket.print "\r\n"
      socket.print(fileBuffer)

      sputs "responded with: ", color: "green"
      sputs response, indent: true

      sputs "closing socket connection with client", color: "green", important: true
      sputs "_____________________________________", color: "green"
      sputs "*************************************", color: "blue"
      sputs "\r\n"
      socket.close

      remove_thread_id
      if Thread.list.length > 2
        sputs "Threads: #{Thread.list.length}", "magenta"
      end
    }
  end
}
rescue Exception => e
  STDERR.puts "caught by main block"
  raise e

rescue Interrupt => e
  dumpHistory
end
