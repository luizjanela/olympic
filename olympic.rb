# olympic.rb

require 'sinatra'
require 'mongo'
require_relative 'competition'
require_relative 'result'

post '/competition/add/' do
  params = JSON.parse(request.env["rack.input"].read)

  competition = Competition.new
  competition.athlets = params["athlets"]
  competition.name = params["name"]
  competition.unit = params["unit"]

  response = competition.save
  "#{response.to_json}"
end

post '/competition/result/add/' do
  params = JSON.parse(request.env["rack.input"].read)

  result = Result.new
  result.athlet = params["athlet"]
  result.competition = params["competition"]
  result.value = params["value"]

  response = result.save
  "#{response.to_json}"
end

post '/competition/finish/' do
  params = JSON.parse(request.env["rack.input"].read)

  competition = Competition.new
  competition.id = params['competition']
  response = competition.finish

  "#{response.to_json}"
end

get '/competition/:id/ranking/' do
  competition = Competition.new
  competition.id = params['id']

  response = competition.ranking

  "#{response.to_json}"
end
