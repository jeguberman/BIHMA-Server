class Route
  attr_reader :identifier, :sub_routes, :klass
  def initialize(identifier: '/', sub_routes: nil, klass: nil)
    @identifier = identifier
    @sub_routes = sub_routes
    @klass = klass


  end


end
