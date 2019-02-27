require 'webrick'
require 'stringio'

class Request < WEBrick::HTTPRequest

  def initialize(socket)
    super WEBrick::Config::HTTP
    self.parse(socket)
    return self
  end

  #because I will be routing for myself and duggan, I am going to go ahead and assume all paths begin with /{space}/realpath
  #I guess technically this should be handled at domain resolution but... eh
  def space
    return "/" + self.path.split("/")[0]
  end
end
  #near as I can tell, webrick scrubs the path automatically.
  # def self.scrub_path(request) #scrub the path to prevent some attacks
  #   #removes the query string
  #   #prevents the request from seeking directories of a higher order than WEB_ROOT
  #
  #   #lol I have no idea what this is, but I assure you, it does
  #   #not "remove a query string"
  #   # path = URI(request_uri).path#removes query string
  #
  #   path = URI.unescape(path)#unescapes URI encoding
  #   #(the fiddly%20bits in the /pathy/strings)
  #
  #   clean_path = []
  #   navigationPoints = path.split("/")
  #   navigationPoints.each do |point|
  #     next if point.empty? || point == '.'
  #     if point== '..'
  #       clean_path.pop
  #     else
  #       clean_path.push(point)
  #     end
  #   end
  #
  #   path = File.join(WEB_ROOT, *clean_path)
  #   return path
  # end
# end
