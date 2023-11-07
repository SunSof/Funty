require 'rails_helper'

RSpec.describe ProcessTransaction, type: :class do
  context 'class methods' do
    describe '::run' do
      it 'add transaction in data base and increment user balance' do
        VCR.use_cassette 'ripple/transaction' do
          user = FactoryBot.create(:user)
          balance = user.balance
          ProcessTransaction.run
          new_balance = User.find(user.id).balance
          expect(new_balance > balance).to eq true
          Transaction.delete_all
        end
      end
    end
  end
end
