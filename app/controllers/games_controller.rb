require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
  @letters = [*('A'..'Z')].sample(10)
  end

  def score

    @word = params[:word_try]
    @grid = params[:grid]
    @start_time = params[:start_time]
    @end_time = Time.now
    @score = 0
    @url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_info_serialized = open(@url).read
    @word_info = JSON.parse(word_info_serialized)
    @result = {}
    @time = @end_time.to_i - @start_time.to_i
    if @word_info["found"] == false
      @result[:score] = 0
      @result[:message] = "Sorry but #{@word} does not seem to be an English word..."
    elsif @time < 5
      @result[:score] = @word_info["length"] + 10
      @result[:message] = "Congratulations ! #{@word} is a valid English word"
    elsif @time < 10
      @result[:score] = @word_info["length"] + 5
      @result[:message] = "Congratulations ! #{@word} is a valid English word"
    else
      @result[:score] = @word_info["length"]
      @result[:message] = "Congratulations ! #{@word} is a valid English word"
    end
    @word.split("").each do |letter|
      unless @grid.downcase.split("").include?(letter)
        @result[:score] = 0
        @result[:message] = "Sorry but #{@word} can't be build with the actual grid"
      end
    end
    @result
  end
end
