require './pet.rb'

use Rack::Reloader, 0
use Rack::Static, :urls => ["/public"]

run Pet
