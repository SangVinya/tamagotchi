require 'erb'

class Render
  attr_accessor :health, :satiety, :happiness, :purity

  def initialize(health, satiety, happiness, purity)
    @health = health
    @satiety = satiety
    @happiness = happiness
    @purity = purity
  end

  def check
    (0...10).include?(@health) ? @health += 1 : @health
  end

  def feed
    (0...10).include?(@satiety) ? @satiety += 1 : @satiety
  end

  def walk
    (0...10).include?(@happiness) ? @happiness += 1 : @happiness
  end

  def wash
    (0...10).include?(@purity) ? @purity += 1 : @purity
  end

  def call(env)
    @request = Rack::Request.new(env)
    case @request.path
    when "/"
      Rack::Response.new(render("index.html.erb"))
    when "/change"
      Rack::Response.new do |response|
        response.set_cookie("greet", @request.params["name"])
        response.redirect("/")
      end
    when "/check"
      Rack::Response.new do |response|
        response.set_cookie("health", check)
        response.set_cookie("happiness", @happiness -= rand(0..2))
        response.set_cookie("satiety", @satiety -= rand(0..1))
        response.redirect("/")
      end
    when "/feed"
      Rack::Response.new do |response|
        response.set_cookie("satiety", feed)
        response.set_cookie("purity", @purity -= rand(0..2))
        response.redirect("/")
      end
    when "/walk"
      Rack::Response.new do |response|
        response.set_cookie("happiness", walk)
        response.set_cookie("satiety", @satiety -= rand(0..2))
        response.set_cookie("purity", @purity -= rand(0..2))
        response.redirect("/")
      end
    when "/wash"
      Rack::Response.new do |response|
        response.set_cookie("purity", wash)
        response.set_cookie("satiety", @satiety -= rand(0..1))
        response.redirect("/")
      end
    when "/new"
      Rack::Response.new do |response|
        response.set_cookie("health", @health = 5)
        response.set_cookie("satiety", @satiety = 5)
        response.set_cookie("happiness", @happiness = 5)
        response.set_cookie("purity", @purity = 5)
        response.redirect("/")
      end
    else
      Rack::Response.new("Not found", 404)
    end
  end

  def render(template)
    path = File.expand_path("./views/#{template}")
    ERB.new(File.read(path)).result(binding)
  end

  def name_value
    @request.cookies["greet"] || "Pet"
  end

  def health_value
    @request.cookies["health"]
  end

  def satiety_value
    @request.cookies["satiety"]
  end

  def happiness_value
    @request.cookies["happiness"]
  end

  def purity_value
    @request.cookies["purity"]
  end
end