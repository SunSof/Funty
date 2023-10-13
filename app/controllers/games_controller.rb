class GamesController < ApplicationController
  def new
    @game = Games.find_game(current_user.id) || Games.create_game(current_user.id)
  end

  def choose
    @number = choose_params[:number]
    Games.save_guess(Game.game_id, current_user.id, @number)
  end

  def result
    @user_num = Games.get_guess(current_user.id)
    game_data = Games.find_game(current_user.id)
    @correct_number = game_data.numbers.fetch(game_data.index_number)
    Games.check_for_correctness(current_user.id, @user_num, @correct_number)
  end

  private

  def choose_params
    params.permit(:number, :id, :authenticity_token)
  end
end
