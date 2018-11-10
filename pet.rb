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
        response.set_cookie("name", "Pet")
        response.set_cookie("health", 5)
        response.set_cookie("satiety", 5)
        response.set_cookie("happiness", 5)
        response.set_cookie("purity", 5)
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
      Rack::Response.new do |response|
        response.set_cookie("health", set(get("health")))
        response.set_cookie("happiness", decrease(get("happiness")))
        response.redirect("/game")
      end
    when "/feed"
      Rack::Response.new do |response|
        response.set_cookie("satiety", set(get("satiety")))
        response.set_cookie("purity", decrease(get("purity")))
        response.redirect("/game")
      end
    when "/walk"
      Rack::Response.new do |response|
        response.set_cookie("happiness", set(get("happiness")))
        response.set_cookie("health", decrease(get("health")))
        response.redirect("/game")
      end
    when "/wash"
      Rack::Response.new do |response|
        response.set_cookie("purity", set(get("purity")))
        response.set_cookie("satiety", decrease(get("satiety")))
        response.redirect("/game")
      end
    when "/restart"
      Rack::Response.new do |response|
        response.set_cookie("health", 5)
        response.set_cookie("satiety", 5)
        response.set_cookie("happiness", 5)
        response.set_cookie("purity", 5)
        response.redirect("/game")
      end
    else
      Rack::Response.new("Not found", 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def set_name
    name = @request.cookies["name"].delete(" ")
    if name.empty?
      "Pet"
    else
      name
    end
  end

  def set(value)
    (0...10).include?(value) ? value += 1 : value
  end

  def get(value)
    @request.cookies["#{value}"].to_i
  end

  def decrease(value)
    value -= rand(0..2)
  end
end
