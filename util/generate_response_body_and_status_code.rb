require 'uri'
require_relative 'render_html.rb'

def generate_response_body_and_status_code(package) #these should be broken down, and the status code should be gotten earlier
  path = package[:path]


  buffer = "" #will carry contents of file
  status_code = 500  #I chose 500 because it seemed like the best default

  if path == "timeout!" #if the server never completed reading the get
    buffer = render_html(title:"408 Timeout", banner: "408 Timeout", message: "The server timed out before it processed your request")
    status_code = 408

  elsif File.split(path).last == "index.html" #if the server was told to return a directory
    buffer = render_html(title: "index", banner: "index")
    status_code = 200

  elsif File.exist?(path) && !File.directory?(path) #if the server was told to serve a specific file
    #respond with a 200 ok status code to indicate christmas is saved
    File.open(path, "rb") do |file|
      buffer = file.read
    end
    status_code = 200

  else  # if the server was told to serve a file that doesn't exist
    buffer = render_html(title: "404 Not Found", banner: "404 not found", message: "The file was not found by the server")
    status_code = 404
  end

  return{
    body: buffer,
    status_code: status_code
  }

end
