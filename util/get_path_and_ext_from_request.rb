def get_path_and_ext_from_request(request_line)

  if(request_line.slice(-1) == "!")
    return {path: request_line, ext: "html"}
  end
  begin#get the desired path from the request line
    request_uri = request_line.split(" ")[1]

  rescue Exception => ex
    sputs "If you're seeing this the request line didn't look the way it ought to. #{__FILE__}".red.onblue.blink
    sputs ex
  end

  path = URI.unescape(URI(request_uri).path)# I confess I no longer remember what this does. It is from the original function. I ASSUME it removes escape characters, and this is such a thoroughly reasonable assumption to me that I daren't investigate it when there is so much to do


#scrub the path to prevent attacks which seek to surpass WEB_ROOT
  clean = []

  navigationPoints = path.split("/")
  navigationPoints.each do |point|
    next if point.empty? || point == '.'
    if point== '..'
      clean.pop
    else
      clean.push(point)
    end
  end


  path = File.join(WEB_ROOT, *clean)

  path = path + "/index.html" if File.directory?(path) #if path is a directory, look for index.html within that directory


  ext = File.extname(path).slice(1..-1)

  return {path: path, ext:ext}
end
