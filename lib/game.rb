class Game
  @@game_id = 'simple_number'
  @@price = 5_000
  attr_reader :numbers, :index_number

  def initialize(numbers, index_number)
    unless numbers.is_a?(Array) && index_number.is_a?(Integer)
      raise ArgumentError,
            'Numbers should be array type, index_number should be integer type'
    end

    @numbers = numbers
    @index_number = index_number
  end

  def self.game_id
    @@game_id
  end

  def self.price
    @@price
  end

  def win_number
    numbers.fetch(index_number)
  end
end
