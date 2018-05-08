require_relative "dyn_html_gen.rb"

CONTENT_TYPE_MAPPING = {
  'html' => "text/html",
  "txt" => 'text/plain',
  'png' => 'image/png',
  'jpg' => 'image/jpeg',
  'css' => 'text/css',
  'js' => 'text/js'
}

DEFAULT_CONTENT_TYPE = 'application/octet-stream' #If you don't know what it is, it's a blob. ... And also a virus

def renderResponse(path)
  if path.slice(-1) == "!"
    return edge_cases(path)
  end

  buffer = "" #will carry contents of file, if file found
  responseHeader = ""



  if File.split(path).last == "index.html"
    responseHeader, buffer = generateHTML
  elsif File.exist?(path) && !File.directory?(path)
    #respond with a 200 ok status code to indicate christmas is saved
    File.open(path, "rb") do |file|
      responseHeader = "HTTP/1.1 200 OK\r\n" +
      "Content-Type: #{content_type(file)}\r\n" +
      "Content-Length: #{file.size}\r\n" +
      "Connection: close\r\n"
      buffer = file.read
    end

  else  # respond with a 404 error code to indicate the file does not exist
    message = "File not found\n"
    File.open("public/no_match.html") do |file|
      responseHeader = "HTTP/1.1 404 Not Found\r\n" +
      "Content-Type: text/html\r\n" +
      "Content-Length: #{file.size}\r\n" +
      "Connection: close\r\n"
      buffer = file.read
    end

  end

  return [responseHeader, buffer]
end

def edge_cases(path)

  case path
  when "timeout!"
    responseHeader = "HTTP/ 1.1 408 Request Timeout\r\n"
    buffer = ""
    # sputs "begin".magenta
    File.open("public/status_codes/timeout.html") do |file|
      responseHeader += "Content-Type: text/html\r\n" +
      "Content-Length: #{file.size}\r\n" +
      "Connection: close\r\n"
      buffer = file.read
    end
    # sputs "end".magenta
  end
  # sputs responseHeader.magenta


  return [responseHeader, buffer]
end

def content_type(path)
  ext = File.extname(path).split(".").last
  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end
