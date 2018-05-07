require 'uri'
require_relative 'thread_util.rb'
require_relative 'log_util.rb'
require_relative 'request_util.rb'
require_relative 'response_util.rb'


def get_file_path(request_line)
  if(request_line.slice(-1) == "!")
    return request_line
  end
  begin
    request_uri = request_line.split(" ")[1]
  rescue Exception => ex
    puts ex
  end

  path = URI.unescape(URI(request_uri).path)# I confess I no longer remember what this does. It is from the original function.

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
