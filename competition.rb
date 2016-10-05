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

  def type
    @type
  end
  
  def type=(type)
    @type = type
  end

  def find
    # Read raking from MongoDB 
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    competition = client[:competition].find({ _id: BSON::ObjectId(@id) }).first

    if !competition
      raise 'Competition not found.'
    end

    puts competition

    @id = competition['_id'].to_s
    @unit = competition['unit']
    @ended = competition['ended']
    @rounds = competition['rounds']
    @type = competition['type']

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
    result = client[:competition].insert_one({ name: @name, unit: @unit, rounds: @rounds, type: @type })
    puts result
    return { id: result.inserted_id.to_s, name: @name, unit: @unit, rounds: @rounds, type: @type }
  end
  
  def ranking
    # Read ranking from MongoDB 
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')

    if @type == "greater"
      valueOrder = -1 # DESC
    else
      valueOrder = 1 # ASC
    end

    ranking = client[:result].find({ competition: @id}).sort({ value: valueOrder, _id: 1 })
    puts ranking.to_a

    simplifiedRanking = {} # Defines a hash

    ranking.to_a.each { |result|
      puts result

      # Gets the first result of the user. As the ranking is returned ordered (ASC or DESC), the first user's result of the list will be better result.
      # If the competition "greater wins", the order will be DESC.
      # Otherwise it will be "lower wins", the order will be ASC.

      if !simplifiedRanking[result['athlet']] 
        simplifiedRanking[result['athlet']] = result['value']
      end
    }

    puts simplifiedRanking.to_json
    return simplifiedRanking
  end 
end 
