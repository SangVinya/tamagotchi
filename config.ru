require './pet_controller.rb'

use Rack::Reloader
run PetController.new(5,5,5,5)
