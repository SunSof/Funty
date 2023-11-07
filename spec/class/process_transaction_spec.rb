require 'rails_helper'

RSpec.describe ProcessTransaction, type: :class do
  context 'class methods' do
    describe '::run' do
      it 'add transaction in data base and increment user balance' do
        VCR.use_cassette 'ripple/transaction' do
          user = FactoryBot.create(:user)
          user.token = 1_122_334_455
          user.save!
          ProcessTransaction.run
          expect(User.first.balance).to eq 13_000_000
          Transaction.delete_all
        end
      end
    end
  end
end
