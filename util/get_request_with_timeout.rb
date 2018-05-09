def get_request_with_timeout(socket)
  request_line = ""
  status = ""
  begin
    # sputs threadID, color: :magenta
    Timeout::timeout(10){
      buffer = socket.gets
      until buffer == "\r\n"
        request_line += buffer
        buffer = socket.gets
      end
    }
    status_feedback = "received request line: ".green
  rescue Exception => e
    request_line = "timeout!"
    status_feedback = "GET request from client timed out!".red
  end
  return status_feedback, request_line
end
