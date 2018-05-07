require 'uri'
require_relative 'thread_util.rb'
require_relative 'log_util.rb'
require_relative 'request_util.rb'
require_relative 'response_util.rb'

def string_from_file(path)
  data = ""
  f = File.open(path,"r")
  f.each_line do |line|
    data += line
  end
  return data
end

def get_requested_file(request_line)
  begin
    request_uri = request_line.split(" ")[1]
  rescue Exception => ex
    puts ex
  end
  path = URI.unescape(URI(request_uri).path)

  clean = []

  parts = path.split("/")

  parts.each do |part|
    next if part.empty? || part == '.'
    if part== '..'
      clean.pop
    else
      clean.push(part)
    end
  end
  File.join(WEB_ROOT, *clean)
end

def content_type(path)
  ext = File.extname(path).split(".").last
  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end
