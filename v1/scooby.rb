class Dog
  attr_accessor :health, :hunger, :happiness, :purity

  def initialize(health, hunger, happiness, purity)
    @health = health
    @hunger = hunger
    @happiness = happiness
    @purity = purity
  end

  def call(env)
    [200, {"Content-Type" => "text/html"}, ["
      <h1>Scooby-Doo</h1>
      <img src='https://www.turner.com/s3fs-public/image_u/img_scrappy_2.JPG' width=20%>
      <p>Health: #{health}</p>
      <p>Hunger: #{hunger}</p>
      <p>Happiness: #{happiness}</p>
      <p>Purity: #{purity}</p>
    "]]
  end

  def name
    puts "What is your pet's name?"
    name = gets.chomp
    puts "\n"
    puts "#{name} was born!"
    dash
  end

  def feed
    @hunger -= 1
    puts "\n"
    puts "You feed your pet"
    dash
  end

  def give_vitamins
    @health += 1
    puts "\n"
    puts "You gave vitamins to your pet"
    dash
  end

  def walk
    @happiness += 1
    puts "\n"
    puts "You walked your pet"
    dash
  end

  def wash
    @purity += 1
    puts "\n"
    puts "You washed your pet"
    dash
  end

  def dash
    puts "-" * 30
  end
end
