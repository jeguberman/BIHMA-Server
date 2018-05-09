#!/usr/bin/env ruby

require 'socket'
require 'uri'
require 'colorize'
require 'timeout'
# require 'os'

require_relative './globals.rb'
require_relative './util/thread_util.rb'
require_relative './util/get_request_with_timeout.rb'
require_relative './util/get_path_and_ext_from_request.rb'
require_relative './util/generate_response_body_and_status_code.rb'
require_relative './util/generate_response_header.rb'
require_relative './util/log_util.rb'

puts ARGV[0]

begin #handle interrupt

WEB_ROOT = ARGV[0] ? Dir.home + ARGV[0] : "samples"

PORT = 2345
HOST = IPSocket.getaddress(Socket.gethostname)
# HOST = "192.168.1.169"

server = TCPServer.new(HOST, PORT)

sputs "Starting Server on host #{Socket.gethostname}(#{HOST}); Listening on port #{PORT}", color: "green", important: true

lock = Mutex.new #prevent different threads from accessing or mutating the same variables


loop {

  Thread.start(server.accept) do |socket|

    # lock.synchronize{
      begin

        add_thread_id
        sputs "_____________________________________", color: "green"

        sputs "opening socket connection with client from #{socket.remote_address.ip_address}", color: "green", important: true

        sputs 'preparing to receive request line...', color: "yellow"

        #GET REQUEST
        request_line_status, request_line = get_request_with_timeout(socket)
        sputs request_line_status, important: true
        sputs request_line, important:true, indent:true

        package={
          path: nil,
          ext: nil,
          buffer: nil,
          status_code: nil,
          response_header: nil
        }

        #GET ROUTE
        package = package.merge get_path_and_ext_from_request(request_line)#add path to package

        #GENERATE RESPONSE
        sputs "rendering response...", color: "yellow"
        package = package.merge generate_response_body_and_status_code(package)
        sputs "response body rendered", color: "green"

        sputs "rendering response header...", color: "yellow"
        package = package.merge(
          generate_response_header(package)
        )
        sputs "response header rendered", color: "green"

        #SEND RESPONSE
        sputs "sending response", color: "yellow"
        socket.print(package[:response_header])
        socket.print "\r\n"
        socket.print(package[:body])
        sputs "responded with: ", color: "green", important: true
        sputs package[:response_header], indent: true, important: true

        #CLOSE SOCKET
        sputs "closing socket connection with client", color: "green", important: true
        socket.close
        sputs "_____________________________________", color: "green"
        sputs "*************************************", color: "blue"
        sputs "\r\n"

        remove_thread_id
      rescue StandardError => e

        sputs e

      end#error net
    # }#mutex
  end#thread
}#loop
rescue Interrupt => e
  dumpHistory
rescue Exception => e
  STDERR.puts "caught by main thread"
end
