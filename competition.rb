#file competition.rb

require 'json/ext'

class Competition  

  # Default size/qty of competition rounds
  @rounds = 1

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
  
  def ended
    @ended
  end
  
  def ended=(ended)
    @ended = ended
  end  

  def rounds
    @rounds
  end
  
  def rounds=(rounds)
    @rounds = rounds
  end

  def find
    # Read raking from MongoDB 
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    competition = client[:competition].find({ _id: BSON::ObjectId(@id) }).first

    puts competition

    @id = competition['id']
    @unit = competition['unit']
    @ended = competition['ended']
    @rounds = competition['rounds']

    return competition
  end

  def finish
    # Finishes the competition, no new result can be added
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    result = client[:competition].update_one({_id: BSON::ObjectId(@id)},{"$set" => {ended: true}})
    return result
  end

  def save
    # Save competition
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    result = client[:competition].insert_one({ name: @name, unit: @unit, rounds: @rounds })
    puts result
    return { id: result.inserted_id.to_s, name: @name, unit: @unit, rounds: @rounds }
  end
  
  def ranking
    # Read ranking from MongoDB 
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    ranking = client[:result].find({ competition: @id }).sort({ value: -1, _id: 1 })
    puts ranking.to_a

    simplifiedRanking = {} # Defines a hash

    ranking.to_a.each { |result|
      puts result
      if !simplifiedRanking[result['athlet']] || result['value'] > simplifiedRanking[result['athlet']]
        simplifiedRanking[result['athlet']] = result['value']
      end
    }

    puts simplifiedRanking.to_json
    return simplifiedRanking
  end 
end 
