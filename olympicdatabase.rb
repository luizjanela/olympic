#file database.rb

require 'json/ext'
require 'mongo'

class OlympicDatabase
	class << self
		def client
			return Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
		end
	end
end  