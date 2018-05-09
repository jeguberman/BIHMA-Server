require 'uri'
require_relative 'render_html.rb'

def generate_response_body_and_status_code(package)
  path = package[:path]


  buffer = "" #will carry contents of file
  status_code = 500  #I chose 500 because it seemed like the best default
  if path == "timeout!"
    buffer = render_html(title:"508 Timeout", banner: "508 Timeout", message: "The server timed out before it processed your request")
    status_code = 508

  elsif File.split(path).last == "index.html"
    buffer = render_html(title: "index", banner: "index")
    status_code = 200
  elsif File.exist?(path) && !File.directory?(path)
    #respond with a 200 ok status code to indicate christmas is saved
    File.open(path, "rb") do |file|
      buffer = file.read
    end
    status_code = 200

  else  # respond with a 404 error code to indicate the file does not exist
    buffer = render_html(title: "404 Not Found", banner: "404 not found")
    status_code = 404
  end

  return{
    body: buffer,
    status_code: status_code
  }

end
