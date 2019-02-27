
#TODO somewhere you need a routes table, and it should be dynamially generated.
#for now just route between you and duggan
class Router

  #TODO even IF you need this... you probably need it to be somewhere else
  PATHS = {duggan: true, goomba: true}

  def initialize()
  end

  def self.route(request)

  end




  def self.VALIDATE_INITIALIZATION_DATA(args)
    if class == nil
      raise ArgumentError.new("No class passed to router in routes.rb")
    end
  end

end
