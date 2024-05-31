class GamesController < ApplicationController

  def new
    @game = Games.find_game(current_user.id) || Games.create_game(current_user.id)
  end

  def restart
    @game = Games.create_game(current_user.id)
    redirect_back(fallback_location: new_game_path)
  end

  def choose
    @number = choose_params[:number]
    Games.save_guess(Game.game_id, current_user.id, @number)
  end

  def result
    @guessed_num = Games.get_guess(current_user.id)
    game = Games.find_game(current_user.id)
    @correct_number = game.win_number
    if @correct_number == @guessed_num
      current_user.increment('winnings', by = 1).save!
      current_user.increment('balance', 15000).save!
    else
      current_user.increment('losses', by = 1).save!
    end
    Games.delete_game(current_user.id)
  end

  private

  def choose_params
    params.permit(:number, :id, :authenticity_token)
  end
end
