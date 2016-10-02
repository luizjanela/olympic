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

  def save
    competition = Competition.new
    competition.id = @competition
    competition.find

    if competition.ended
	return false
    end
    
    client = Mongo::Client.new('mongodb://127.0.0.1:27017/olympic')
    result = client[:result].insert_one({ competition: @competition, athlet: @athlet, value: @value })
    return result
  end

end 
