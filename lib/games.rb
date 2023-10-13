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

  def self.save_guess(game_id, user_id, number)
    $redis.set("#{game_id}_#{user_id}_number", number)
  end

  def self.get_guess(user_id)
    $redis.get("#{Game.game_id}_#{user_id}_number").to_i
  end

  def self.correct_number(user_id)
    game = Games.find_game(user_id)
    game.numbers.fetch(game.index_number)
  end

  def self.delete_game(user_id)
    $redis.del("#{Game.game_id}_#{user_id}")
  end
end
