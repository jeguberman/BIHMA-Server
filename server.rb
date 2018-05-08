#!/usr/bin/env ruby

require 'socket'
require 'uri'
require 'colorize'
require 'timeout'
require 'byebug'
require 'os'

require_relative './globals.rb'
require_relative './util/util.rb'

puts ARGV[0]

begin #handle interrupt

WEB_ROOT = ARGV[0] ? Dir.home + ARGV[0] : "./public"

PORT = 2345
HOST = IPSocket.getaddress(Socket.gethostname)
# HOST = "192.168.1.169"

server = TCPServer.new(HOST, PORT)

sputs "Starting Server 2 on host #{Socket.gethostname}(#{HOST}); Listening on port #{PORT}", color: "green", important: true

lock = Mutex.new #prevent different threads from accessing or mtuating the same variables


loop {
  Thread.start(server.accept) do |socket|
    lock.synchronize{
      begin

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
        socket.close
        sputs "_____________________________________", color: "green"
        sputs "*************************************", color: "blue"
        sputs "\r\n"

        remove_thread_id
        # if Thread.list.length > 1
        sputs "Threads: #{Thread.list}", color: "magenta"
        # end
      rescue StandardError => e
        # STDERR.puts "ERROR".black.on_red
        sputs e
        # STDERR.puts e
        # STDERR.puts e.backtrace
        Thread.kill Thread.current
      end#error net
    }#mutex
  end#thread
}#loop
rescue Interrupt => e
  dumpHistory

rescue Exception => e
  STDERR.puts "caught by main thread"
  fail

end
