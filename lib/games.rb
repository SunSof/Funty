class Games
  def self.find_game(user_id)
    return unless (game_data = $redis.get("#{Game.game_id}_#{user_id}"))

    game = eval(game_data)
    Game.new(game[0], game[1])
  end

  def self.create_game(user_id)
    $redis.set("#{Game.game_id}_#{user_id}", [[*10..99].sample(4), [*0..3].sample])
    game_data = eval($redis.get("#{Game.game_id}_#{user_id}"))
    Game.new(game_data[0], game_data[1])
  end

  def self.check_for_correctness(user_id, user_num, correct_number)
    current_user = User.find_by(id: user_id)
    if user_num == correct_number
      current_user.increment('winnings', by = 1).save!
    else
      current_user.increment('losses', by = 1).save!
    end
    $redis.del("#{Game.game_id}_#{user_id}")
  end

  def self.save_guess(game_id, user_id, number)
    $redis.set("#{game_id}_#{user_id}_number", number)
  end

  def self.get_guess(user_id)
    $redis.get("#{Game.game_id}_#{user_id}_number").to_i
  end
end
