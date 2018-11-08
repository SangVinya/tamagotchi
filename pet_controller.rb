class PetController
  attr_accessor :health, :satiety, :happiness, :purity

  def initialize(health, satiety, happiness, purity)
    @health = health
    @satiety = satiety
    @happiness = happiness
    @purity = purity
  end

  def name
    puts "What is your pet's name?"
    name = gets.chomp
    puts "#{name} was born!"
  end

  def check
    if health > 0 && health < 10
      @health += 1
    else
      puts "THE END"
    end
  end

  def feed
    if satiety > 0 && satiety < 10
      @satiety += 1
    else
      puts "THE END"
    end
  end

  def walk
    if happiness > 0 && happiness < 10
      @happiness += 1
    else
      puts "THE END"
    end
  end

  def wash
    if purity > 0 && purity < 10
      @purity += 1
    else
      puts "THE END"
    end
  end

  def call(env)
    template = File.read('./root.html')
    [200, {"Content-Type" => "text/html"}, [ERB.new(template).result(binding)]]
  end
end
