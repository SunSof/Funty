require 'rails_helper'

RSpec.describe WithdrawFunds, type: :class do
  context 'class methods' do
    describe '::user_enough_funds?' do
      it 'return true if user has enough funds' do
        user = FactoryBot.create(:user)
        expect(WithdrawFunds.user_enough_funds?(user, 10_000)).to eq true
      end
      it 'return true if user hasnt enough funds' do
        user = FactoryBot.create(:user)
        user.balance = 0
        user.save!
        expect(WithdrawFunds.user_enough_funds?(user, 10_000)).to eq false
      end
    end
    describe '::app_enough_funds?' do
      it 'return true if app has enough funds' do
        VCR.use_cassette 'withdraw_funds/app_funds' do
          account = 'rEX5oz43exnmJZjjfaVifNy3rqAnuMjFE7'
          expect(WithdrawFunds.app_enough_funds?(account, 10_000)).to eq true
        end
      end
      it 'return true if app hasnt enough funds' do
        VCR.use_cassette 'withdraw_funds/app_funds' do
          account = 'rEX5oz43exnmJZjjfaVifNy3rqAnuMjFE7'
          expect(WithdrawFunds.app_enough_funds?(account, 10_000_000_000_000)).to eq false
        end
      end
    end
    describe '::withdraw' do
      it 'return :user_not_enought_funds if user hasnt enough funds' do
        user = FactoryBot.create(:user)
        user.balance = 0
        user.save!
        user_address = 'rDMTLGgdYwuCpP385LayLfmB1aknd5LVa'
        amount = 100_000

        VCR.use_cassette 'withdraw_funds/withdraw' do
          expect(WithdrawFunds.withdraw(user.id, user_address, amount)).to eq :user_not_enought_funds
        end
      end
      it 'decrement user balance if the transaction complited' do
        user = FactoryBot.create(:user)
        user_address = 'rDMTLGgdYwuCpP385LayLfmB1aknd5LVa'
<<<<<<< withdraw_funds
        amount = 10000
=======
        amount = 100_000
>>>>>>> main
        user_balance_before = user.balance

        VCR.use_cassette 'withdraw_funds/withdraw' do
          WithdrawFunds.withdraw(user.id, user_address, amount)
          user_balance_after = User.find(user.id).balance
          expect(user_balance_before > user_balance_after).to eq true
        end
      end
    end
  end
end
