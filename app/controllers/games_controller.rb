class GamesController < ApplicationController
  def new
    @game = Games.find_game(current_user.id) || Games.create_game(current_user.id)
  end

  def choose
    @number = choose_params[:number]
    $redis.set("number_#{Game.game_id}_#{current_user.id}", @number)
  end

  def result
    @user_num = $redis.get("number_#{Game.game_id}_#{current_user.id}").to_i
    game_data = eval($redis.get("#{Game.game_id}_#{current_user.id}"))
    @correct_number = game_data[0].fetch(game_data[1])
    Games.check_for_correctness(current_user.id, @user_num, @correct_number)
  end

  private

  def choose_params
    params.permit(:number, :id, :authenticity_token)
  end
end
