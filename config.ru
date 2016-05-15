require './app'

Rack::Handler.get('puma').run MappingLearning.new
