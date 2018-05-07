def getRequestWithTimeout(socket)
  request_line = ""
  status = ""
  options = {color: ""}
  begin
    Timeout::timeout(5){
      request_line += socket.gets
    }
    puts request_line
    status = "received request line: ".green
  rescue Exception => e
    request_line = "timeout!"
    status = "GET request from client timed out!".red
  end
  return status, request_line
end
