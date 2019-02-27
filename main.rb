#!/usr/bin/env ruby

require 'socket'
require 'uri'
require 'colorize'
require 'timeout'

require 'byebug'


require_relative './globals.rb'
require_relative './util/thread_util.rb'
require_relative './util/log_util.rb'

require_relative './util/get_host_address.rb'
require_relative './util/get_request_with_timeout.rb'
# require_relative './util/router/router.rb'
require_relative './util/generate_response_body_and_status_code.rb'
require_relative './util/generate_response_header.rb'
require_relative './util/request.rb'

#TODO there's a ruby class object to handle gnu args. Until you have utilized this class correctly, you have no reached version 4
OptionsHandler.set_globals_from_argv

begin #handle interrupt (ctrl+c)
  #Begin watching for interupt so the logger can dump this session's log before closing the program

WEB_ROOT = $GLOBALS[:path]
#port numbers will be handled by the container and as such, be set in docker-compose
PORT = 9001 #every tutorial suggests using a high port number. This port number is very high, it's over 9000.
HOST = get_host_address_ipv4
#this information is retrieved from functions because most people have dynamic ip assignment. #Lessons.1

server = TCPServer.new(HOST, PORT)

sputs "Serving #{WEB_ROOT} on host #{Socket.gethostname}(#{HOST}); Listening on port #{PORT}", color: "green", important: true


# lock = Mutex.new #prevent different threads from accessing or mutating the same variables. I am convinced that I have not been using this correctly and I am convinced that this is a necessary part of threading

loop {

  # Thread.start(server.accept) do |socket| #Threading is used so the server can handle multiple requests at once. Strictly speaking this probably isn't necessary for such a small program, this is a case of taking on a responsibility because I wanted to learn it.
  socket = server.accept

    # lock.synchronize{ #originally I just threw a mutex lock around an entire thread and hoped for the best. Obviously this is kind of silly since  locking an entire thread does... very very little. If I understand mutex and threading correctly, any variables established inside of a thread should exist within their own context. Meaning two threads at the same point of execution can both use the same variable names. Locking should only be necessary when accessing variables declared outside the scope of the thread. Because my globals are set and unchanged before any threads are created, I shouldn't actually need to do any locking, but a mentor has informed me that this is still considered best practice.

      begin
        #I started an inner begin error handling because I found the program wasn't crashing correctly. I didn't fully understand why and I still don't fully understand why. I know it has something to do with my logger. I've since learned Ruby has it's own logging class I intend to look into.

        request = Request.new(socket)
        #ESTABLISH CONNECTION
        add_thread_id
        sputs "_____________________________________", color: "green"
        sputs "opening socket connection with client from " +
        "#{socket.remote_address.ip_address}", color: "green", important: true
        sputs 'preparing to receive request line...', color: "yellow"

        #GET REQUEST
        # request_line_status, request_line = get_request_with_timeout(socket)
        # sputs request_line_status, important: true
        # sputs request_line, important:true, indent:true
        # sleep(2)


        # request = Request.discharge_request_pod_from_suckling_wyrm(socket)
        # sputs request.request_line, important: true
        # sputs request.request_headers, important: true
        # #TODO find out if you need this sleep. I'll bet you don't.
        # sleep(2)



        package={
          path: nil,
          ext: nil,
          buffer: nil,
          status_code: nil,
          response_header: nil
        } #Package is a bundle of information to be passed down the assembly line generating our response.

        #GET ROUTE
        # package = package.merge get_path_and_ext_from_request(request_line)#add path to package
        # debugger
        # package = package.merge Router.route(request)#add

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
  # end#thread
}#loop
rescue Interrupt => e
  dumpHistory
rescue Exception => e
  STDERR.puts "caught by main thread"
  raise e
end
