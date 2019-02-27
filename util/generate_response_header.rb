CONTENT_TYPE_MAPPING = {
  'html' => "text/html",
  "txt" => 'text/plain',
  'png' => 'image/png',
  'jpg' => 'image/jpeg',
  'css' => 'text/css',
  'js' => 'text/js',

  'zip' => 'application/zip'
}
CONTENT_TYPE_MAPPING.default = 'application/octet-stream'#If the server don't know what it is, then it's an 8bit blob. ... And also a virus

STATUS_CODES = {
  200 => "OK",
  204 => "No Content",
  400 => "Bad Request",
  404 => "Not Found",
  408 => "Request Timeout",
  500 => "Internal Server Error"
}

STATUS_CODES.default = "Internal Server Error"


def generate_response_header(package)

  body = package[:body]
  ext = package[:ext]
  status_code = package[:status_code]
  status = STATUS_CODES[package[:status_code]]

  response_header = "HTTP/1.1 #{status_code} #{status}\r\n" +
  "Content-Type: #{CONTENT_TYPE_MAPPING[ext]}\r\n" +
  "Content-Length: #{body.bytesize}\r\n" +
  "Connection: close\r\n"
  return { response_header: response_header }
end
