def get_path_and_ext_from_request(request_line)

  if(request_line.slice(-1) == "!")
    return {path: request_line, ext: "html"}
  end

  request_uri = request_line.split(" ")[1]

  path = scrub_path(request_uri)

  path = path + "/index.html" if File.directory?(path) #if path is a directory, look for index.html within that directory

  ext = File.extname(path).slice(1..-1)

  return {path: path, ext:ext}
end

def scrub_path(request_uri) #scrub the path to prevent some attacks
  #removes the query string
  #prevents the request from seeking directories of a higher order than WEB_ROOT

  path = URI(request_uri).path#removes query string
  path = URI.unescape(path)#unescapes URI encoding

  clean_path = []
  navigationPoints = path.split("/")
  navigationPoints.each do |point|
    next if point.empty? || point == '.'
    if point== '..'
      clean_path.pop
    else
      clean_path.push(point)
    end
  end

  path = File.join(WEB_ROOT, *clean_path)
  return path
end
