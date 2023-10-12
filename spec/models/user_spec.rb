require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with name, email, password' do
      user = User.create(name: 'ABC', email: 'friend@gmail.com', password: '123456', password_confirmation: '123456')

      expect(user).to be_valid
    end

    it 'is invalid without name' do
      user = User.create(name: '', email: 'friend@gmail.com', password: '123456', password_confirmation: '123456')

      expect(user).not_to be_valid
      expect(user.errors.full_messages).to eq ["Name can't be blank", 'Name is too short (minimum is 2 characters)']
    end

    it 'is invalid without password' do
      user = User.create(name: 'ABC', email: 'friend@gmail.com', password: '', password_confirmation: '')

      expect(user).not_to be_valid
      expect(user.errors.full_messages).to eq ['Password is too short (minimum is 6 characters)',
                                               "Password confirmation can't be blank"]
    end

    it 'is invalid when password confirmation doesnt match with password' do
      user = User.create(name: 'ABC', email: 'friend@gmail.com', password: '123456', password_confirmation: '')

      expect(user).not_to be_valid
      expect(user.errors.full_messages).to eq ["Password confirmation doesn't match Password",
                                               "Password confirmation can't be blank"]
    end

    it 'is invalid without email' do
      user = User.create(name: 'ABC', email: '', password: '123456', password_confirmation: '123456')

      expect(user).not_to be_valid
      expect(user.errors.full_messages).to eq ["Email can't be blank", 'Email is invalid']
    end
  end

  context 'callbacks' do
    it 'set email to downcase' do
      user = User.create(name: 'ABC', email: 'FRIEND@mail.com', password: '123456', password_confirmation: '123456')

      expect(user.email).to eq 'friend@mail.com'
    end

    it 'validate email format' do
      user = User.create(name: 'ABC', email: '1', password: '123456', password_confirmation: '123456')

      expect(user).not_to be_valid
      expect(user.errors.full_messages).to eq ['Email is invalid']
    end

    it 'return error if there is an user with similar email' do
      user1 = User.create(name: 'ABC', email: 'best@mail.com', password: '654321', password_confirmation: '654321')
      user2 = User.create(name: 'ABC', email: 'BEST@mail.com', password: '123456', password_confirmation: '123456')

      expect(user2).not_to be_valid
      expect(user2.errors.full_messages).to eq ['Email has already been taken']
    end
  end
end
