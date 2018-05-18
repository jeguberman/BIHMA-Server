#!/usr/bin/env ruby

require 'socket'
require 'uri'
require 'colorize'
require 'timeout'
require 'byebug'
# require 'os'

require_relative './globals.rb'
require_relative './util/thread_util.rb'
require_relative './util/log_util.rb'

require_relative './util/get_host_address.rb'
require_relative './util/get_request_with_timeout.rb'
require_relative './util/get_path_and_ext_from_request.rb'
require_relative './util/generate_response_body_and_status_code.rb'
require_relative './util/generate_response_header.rb'

OptionsHandler.set_globals_from_argv

begin #handle interrupt (ctrl+c)
  #Begin watching for interupt so the logger can dump this session's log before closing the program

WEB_ROOT = $GLOBALS[:path]
PORT = 9001 #every tutorial suggests using a high port number. This port number is very high, it's over 9000.
HOST = get_host_address_ipv4

server = TCPServer.new(HOST, PORT)

sputs "Serving #{WEB_ROOT} on host #{Socket.gethostname}(#{HOST}); Listening on port #{PORT}", color: "green", important: true


# lock = Mutex.new #prevent different threads from accessing or mutating the same variables

loop {

  Thread.start(server.accept) do |socket|

    # lock.synchronize{
      begin
        #ESTABLISH CONNECTION
        add_thread_id
        sputs "_____________________________________", color: "green"
        sputs "opening socket connection with client from " +
        "#{socket.remote_address.ip_address}", color: "green", important: true
        sputs 'preparing to receive request line...', color: "yellow"

        #GET REQUEST
        request_line_status, request_line = get_request_with_timeout(socket)
        sputs request_line_status, important: true
        sputs request_line, important:true, indent:true
        sleep(2)

        package={
          path: nil,
          ext: nil,
          buffer: nil,
          status_code: nil,
          response_header: nil
        } #Package is a bundle of information to be passed down the assembly line generating our response. 

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
        Thread.kill Thread.current

      end#error net
    # }#mutex
  end#thread
}#loop
rescue Interrupt => e
  dumpHistory
rescue Exception => e
  STDERR.puts "caught by main thread"
  raise e
end
