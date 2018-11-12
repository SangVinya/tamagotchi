require 'erb'

class Pet
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/"
      Rack::Response.new do |response|
        response.set_cookie("name", set_name)
        values = ["health", "satiety", "happiness", "purity"]
        values.each { |value| response.set_cookie(value, 5) }
        response.redirect("/game")
      end
    when "/game"
      if get("health") <= 0 || get("satiety") <= 0 || get("happiness") <= 0 || get("purity") <= 0
        Rack::Response.new(render("game_over.html.erb"))
      else
        Rack::Response.new(render("index.html.erb"))
      end
    when "/change"
      Rack::Response.new do |response|
        response.set_cookie("name", @request.params["name"])
        response.redirect("/game")
      end
    when "/check"
      build_response("health", "happiness")
    when "/feed"
      build_response("satiety", "purity")
    when "/walk"
      build_response("happiness", "health")
    when "/wash"
      build_response("purity", "satiety")
    else
      Rack::Response.new("Not found", 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def build_response(value_for_increase, value_for_decrease)
    Rack::Response.new do |response|
      response.set_cookie("#{value_for_increase}", increase(get("#{value_for_increase}")))
      response.set_cookie("#{value_for_decrease}", decrease(get("#{value_for_decrease}")))
      response.redirect("/game")
    end
  end

  def set_name
    name = @request.cookies["name"]
    if name.nil? || name.empty?
      name = "Pet"
    else
      name
    end
  end

  def increase(value)
    (0...10).include?(value) ? value += 1 : value
  end

  def get(value)
    @request.cookies["#{value}"].to_i
  end

  def decrease(value)
    value -= rand(0..2)
  end
end
