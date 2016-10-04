#file competition.rb

require 'json/ext'

class Result  
  def initialize
  end  
  
  def competition
    @competition
  end
  
  def competition=(competition)
    @competition = competition
  end
  def athlet
    @athlet
  end
  
  def athlet=(athlet)
    @athlet = athlet
  end

  def value
    @value
  end
  
  def value=(value)
    @value = value
  end

  def roundsAlreadyPlayer(competitionId, athletId)
    # Read ranking from MongoDB 
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    rounds = client[:result].find({ competition: competitionId, athlet: athletId }).count()

    puts "Rounds already played #{rounds}"
    return rounds
  end

  def save
    # Saves/adds new competition
    competition = Competition.new
    competition.id = @competition
    competition.find

    if competition.ended
	    raise 'Competition already ended.'
    end

    roundsAlreadyPlayed = self.roundsAlreadyPlayer(@competition, @athlet)

    puts "Rounds played " + roundsAlreadyPlayed.to_s
    puts "Rounds " + competition.rounds.to_s

    if roundsAlreadyPlayed >= competition.rounds
      raise 'All rounds of this athlet already have been played.' 
    end
    
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    result = client[:result].insert_one({ competition: @competition, athlet: @athlet, value: @value })

    return { id: result.inserted_id.to_s, competition: @competition, athlet: @athlet, value: @value }
  end

end 
