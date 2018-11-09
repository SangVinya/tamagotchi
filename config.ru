require './render.rb'

use Rack::Reloader, 0

run Render.new(5,5,5,5)
