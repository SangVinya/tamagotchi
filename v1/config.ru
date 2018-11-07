require './scooby.rb'

use Rack::Reloader
run Dog.new(5,5,5,5)
