<<<<<<< HEAD
require './pet.rb'

use Rack::Reloader, 0
use Rack::Static, :urls => ["/public"]

run Pet
=======
require './render.rb'

use Rack::Reloader, 0

run Render.new(5,5,5,5)
>>>>>>> efa94ce9cdf3259a0fba4bf978b65ed8cfc12b2b
