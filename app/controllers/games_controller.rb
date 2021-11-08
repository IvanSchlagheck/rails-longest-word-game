require 'open-uri'
require 'json'

class GamesController < ApplicationController
  ABC = ('A'..'Z').to_a

  def generate_grid
    grid = []
    10.times { grid << ABC[rand(ABC.size)] }
     return grid
  end

  def run_game(guess, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    # get_word_from_api(attempt)
    if !get_word_from_api(guess)
      @hash = { score: 0, message: "not an english word" }
    elsif !validate_attempt(guess.upcase, grid)
      @hash = { score: 0, message: "not in the grid" }
    else
      @hash = { score: 1 * guess.size, message: "well done" }
    end
    return @hash
  end

  def validate_attempt(guess, grid)
    letters = guess.chars
    letters.all? { |letter| letters.count(letter) <= grid.count(letter) }
  end

  def get_word_from_api(guess)
    url = "https://wagon-dictionary.herokuapp.com/#{guess}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    return word["found"]
  end

  def new
    @letters = generate_grid
  end

  def score
    guess = params[:guess]
    auth_token = params[:authenticity_token]
    run_game(guess, auth_token)
  end
end
