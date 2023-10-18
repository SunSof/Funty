require 'rails_helper'

RSpec.describe Game, type: :class do
  describe 'initialize' do
    it 'is initialized in class with the correct class type' do
      game = Game.new([1, 2, 3, 4], 2)

      expect(game.numbers).to eq [1, 2, 3, 4]
      expect(game.index_number).to eq 2
    end

    it 'is not initialized without the correct class type in a first argument' do
      expect { Game.new('abc', 2) }.to raise_error(ArgumentError)
    end

    it 'is not initialized without the correct class type in a second argument' do
      expect { Game.new([1, 2, 3, 4], 'abc') }.to raise_error(ArgumentError)
    end
  end
  context 'instance methods' do
    describe '#win_number' do
      it 'return win number' do
        user = FactoryBot.create(:user)
        $redis.set("#{Game.game_id}_#{user.id}", [[1, 2, 3, 4], 1])
        game = Games.find_game(user.id)
        expect(game.win_number).to eq 2
      end
    end
  end
end
