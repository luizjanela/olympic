# olympic.rb

require 'sinatra'
require 'mongo'
require_relative 'competition'
require_relative 'result'

post '/competition/add/' do
  begin
    params = JSON.parse(request.env["rack.input"].read)

    competition = Competition.new
    competition.name = params["name"]
    competition.unit = params["unit"]
    competition.rounds = params["rounds"]

    if params["type"] == "greater"
      competition.type = "greater"
    else
      competition.type = "lower"
    end

    response = competition.save
    "{\"result\":true, \"message\":\"Competition created.\", \"data\":#{response.to_json}}"

  rescue Exception => e
    "{\"result\":false, \"message\":\"#{e.message}\", \"data\":null}"
  end
end

post '/competition/result/add/' do
  begin
    params = JSON.parse(request.env["rack.input"].read)

    result = Result.new
    result.athlet = params["athlet"]
    result.competition = params["competition"]
    result.value = params["value"]

    response = result.save
    "{\"result\":true, \"message\":\"Result added.\", \"data\":#{response.to_json}}"

  rescue Exception => e
    "{\"result\":false, \"message\":\"#{e.message}\", \"data\":null}"
  end
end

post '/competition/finish/' do
  begin
    params = JSON.parse(request.env["rack.input"].read)

    competition = Competition.new
    competition.id = params['competition']
    response = competition.finish

    "{\"result\":true, \"message\":\"Competition finished.\", \"data\":null}"

  rescue Exception => e
    "{\"result\":false, \"message\":\"#{e.message}\", \"data\":null}"
  end
end

get '/competition/:id/ranking/' do
  begin

    competition = Competition.new
    competition.id = params['id']
    competition.find

    response = competition.ranking

    "{\"result\":true, \"message\":null, \"data\":#{response.to_json}}"

  rescue Exception => e
    "{\"result\":false, \"message\":\"#{e.message}\", \"data\":null}"
  end
end
