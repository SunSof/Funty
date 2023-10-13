require 'rails_helper'

RSpec.describe Games, type: :class do
  context 'class methods' do
    describe '::find_game' do
      it 'finds the game in redis and return game' do
        user_id = 2
        game = $redis.set("#{Game.game_id}_#{user_id}", [[1, 2, 3, 4], 1])
        expect(Games.find_game(2)).to be_a Game
        expect(Games.find_game(2).index_number).to eq 1
        expect(Games.find_game(2).numbers).to eq [1, 2, 3, 4]
        $redis.del("#{Game.game_id}_#{user_id}")
      end
    end
    describe '::create_game' do
      it 'creates the game in redis and return new game' do
        user_id = 2
        game = Games.create_game(user_id)
        redis_data = eval($redis.get("#{Game.game_id}_#{user_id}"))
        expect(redis_data[0]).to eq game.numbers
        expect(redis_data[1]).to eq game.index_number
        $redis.del("#{Game.game_id}_#{user_id}")
      end
    end
    describe '::check_for_correctness' do
      it 'compares data and scores a point when user lose' do
        user_create = User.create(name: 'Abc', email: 'friend@gmail.com', password: '123456',
                                  password_confirmation: '123456')

        user_id = user_create.id
        Games.check_for_correctness(user_id, 10, 20)
        user = User.find_by(id: user_id)
        expect(user.losses).to eq 1
        expect(user.winnings).to eq 0
      end
      it 'compares data and scores a point when user win' do
        user_create = User.create(name: 'Abc', email: 'friend@gmail.com', password: '123456',
                                  password_confirmation: '123456')

        user_id = user_create.id
        Games.check_for_correctness(user_id, 20, 20)
        user = User.find_by(id: user_id)
        expect(user.winnings).to eq 1
        expect(user.losses).to eq 0
      end
    end

    describe '::save_guess' do
      it 'checks if the value is saved' do
        user_id = 2
        number = 10
        Games.save_guess(Game.game_id, user_id, number)
        data = eval($redis.get("#{Game.game_id}_#{user_id}_number"))
        expect(data).to eq 10
        $redis.del("#{Game.game_id}_#{user_id}_number")
      end
    end

    describe '::get_guess' do
      it 'gets value from redis' do
        user_id = 2
        number = 10
        Games.save_guess(Game.game_id, user_id, number)
        expect(Games.get_guess(user_id)).to eq 10
        $redis.del("#{Game.game_id}_#{user_id}_number")
      end
    end
  end
end
