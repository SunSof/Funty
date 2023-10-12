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
end
