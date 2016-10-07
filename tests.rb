# tests.rb

require_relative "competition"
require_relative "result"

describe Competition do

	describe "1 round competition" do

		before(:each) do
			@competition = Competition.new
		    @competition.name = "100m"
		    @competition.unit = "s"
		    @competition.rounds = 1
		    @competition.type = "lower"

		    @competition.save
		end

		describe ".new" do
			context "given a new competition object" do
				it "has empty (nil) attributes" do
					competition = Competition.new

					expect(competition.id).to eql(nil)
					expect(competition.name).to eql(nil)
					expect(competition.ended).to eql(nil)
					expect(competition.rounds).to eql(nil)
					expect(competition.type).to eql(nil)
				end
			end
		end

		describe ".find" do
			context "given a valid competition" do
				it "has an id" do
					expect(@competition.id).not_to eq(nil)
				end
				it "can be found" do
					foundCompetition = Competition.new
					foundCompetition.id = @competition.id
					foundCompetition.find

					expect(foundCompetition).not_to eq(nil)
					expect(foundCompetition.id).to eq(@competition.id)
					expect(foundCompetition.name).to eq(@competition.name)
					expect(foundCompetition.unit).to eq(@competition.unit)
					expect(foundCompetition.type).to eq(@competition.type)
					expect(foundCompetition.rounds).to eq(@competition.rounds)
				end
			end
		end

		describe ".ranking" do
			context "given a new competition" do
				it "has no results" do
					expect(@competition.ranking).to eq({})
				end
			end

			context "given a competition with only 1 result" do
				it "has only this result" do

					@result = Result.new
				    @result.competition = @competition.id
				    @result.athlet = "Luiz Janela"
				    @result.value = 1.5
				    @result.save

					expect(@competition.ranking).to eq({"Luiz Janela" => 1.5})
				end
			end

			context "given an ended competition" do
				it "cant accept a new result" do

					@competition.finish

					@result = Result.new
				    @result.competition = @competition.id
				    @result.athlet = "Luiz Janela"
				    @result.value = 1.5
					
					expect{@result.save}.to raise_error('Competition already ended.')
					expect(@competition.ranking).to eq({})
				end
			end

			context "given a 'lower wins' competition with 2 different results" do
				it "lowest wins" do

					@result = Result.new
				    @result.competition = @competition.id
				    @result.athlet = "Luiz Janela"
				    @result.value = 1.5
				    @result.save

					@result = Result.new
				    @result.competition = @competition.id
				    @result.athlet = "Usain Bolt"
				    @result.value = 3.8
				    @result.save

					expect(@competition.ranking).to eq({"Luiz Janela" => 1.5, "Usain Bolt" => 3.8})
				end
			end

			context "given a 'lower wins' competition with 2 different results" do
				it "can only accept 1 result of each athlet" do

					@result = Result.new
				    @result.competition = @competition.id
				    @result.athlet = "Luiz Janela"
				    @result.value = 1.5
				    @result.save

					@result = Result.new
				    @result.competition = @competition.id
				    @result.athlet = "Luiz Janela"
				    @result.value = 1.0
				    
				    expect{@result.save}.to raise_error('All rounds of this athlet already have been played.')
					expect(@competition.ranking).to eq({"Luiz Janela" => 1.5})
				end
			end
		end
	end

	describe "N rounds 'lower wins' competition" do

		before(:each) do
			@competition = Competition.new
		    @competition.name = "100m"
		    @competition.unit = "s"
		    @competition.rounds = 10
		    @competition.type = "lower"

		    @competition.save
		end

		context "given a 'lower wins' competition with many results" do
			it "lowest result of each athlet is present listed on ranking on a ASC order" do

				@result = Result.new
			    @result.competition = @competition.id
			    @result.athlet = "Luiz Janela"
			    @result.value = 1.5
			    @result.save

				@result = Result.new
			    @result.competition = @competition.id
			    @result.athlet = "Usain Bolt"
			    @result.value = 3.0
			    @result.save

				@result = Result.new
			    @result.competition = @competition.id
			    @result.athlet = "Luiz Janela"
			    @result.value = 0.5
			    @result.save

			    @result = Result.new
			    @result.competition = @competition.id
			    @result.athlet = "Usain Bolt"
			    @result.value = 2.7
			    @result.save

			    @result = Result.new
			    @result.competition = @competition.id
			    @result.athlet = "Usain Bolt"
			    @result.value = 4.5
			    @result.save

				expect(@competition.ranking).to eq({"Luiz Janela" => 0.5, "Usain Bolt" => 2.7})
			end
		end
	end

	describe "N rounds 'greater wins' competition" do

		before(:each) do
			@competition = Competition.new
		    @competition.name = "Arremesso de dardo"
		    @competition.unit = "s"
		    @competition.rounds = 10
		    @competition.type = "greater"

		    @competition.save
		end

		context "given a 'greater wins' competition with many results" do
			it "greatest result of each athlet is present listed on ranking on a DESC order" do

				@result = Result.new
			    @result.competition = @competition.id
			    @result.athlet = "Luiz Janela"
			    @result.value = 260.30
			    @result.save

				@result = Result.new
			    @result.competition = @competition.id
			    @result.athlet = "Julius Yego"
			    @result.value = 200.45
			    @result.save

				@result = Result.new
			    @result.competition = @competition.id
			    @result.athlet = "Luiz Janela"
			    @result.value = 150.99
			    @result.save

			    @result = Result.new
			    @result.competition = @competition.id
			    @result.athlet = "Julius Yego"
			    @result.value = 210.90
			    @result.save

			    @result = Result.new
			    @result.competition = @competition.id
			    @result.athlet = "Julius Yego"
			    @result.value = 245.86
			    @result.save

				expect(@competition.ranking).to eq({"Luiz Janela" => 260.30, "Julius Yego" => 245.86})
			end
		end
	end
end
