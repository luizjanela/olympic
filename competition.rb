#file competition.rb

require 'json/ext'

class Competition  
  def initialize
  end  
  
  def id
    @id
  end
  
  def id=(id)
    @id = id
  end
  
  def name
    @name
  end
  
  def name=(name)
    @name = name
  end
  
  def unit
    @unit
  end
  
  def unit=(unit)
    @unit = unit
  end
  
  def athlets
    @athlets
  end
  
  def athlets=(athlets)
    @athlets = athlets
  end
  
  def ended
    @ended
  end
  
  def ended=(ended)
    @ended = ended
  end

  def find
    # Read raking from MongoDB 
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    competition = client[:competition].find({ _id: BSON::ObjectId(@id) }).first

    puts competition

    @athlets = competition['athlets']
    @id = competition['id']
    @unit = competition['unit']
    @ended = competition['ended']

    return competition
  end

  def finish
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    result = client[:competition].update_one({_id: BSON::ObjectId(@id)},{"$set" => {ended: true}})
    return result
  end

  def save
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    result = client[:competition].insert_one({ name: @name, unit: @unit, athlets: @athlets })
    return result
  end
  
  def ranking
    # Read raking from MongoDB 
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    gameplay = client[:result].find({ competition: @id }).sort({ value: -1 }).first

    puts gameplay
    return gameplay
  end 
end 
