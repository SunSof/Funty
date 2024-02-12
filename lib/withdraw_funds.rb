class WithdrawFunds
  def self.user_enough_funds?(user, amount)
    user.balance >= amount
  end

  def self.app_enough_funds?(account = ENV['ACCOUNT_ADDRESS'], amount)
    data = RippleClient.account_info(account)
    balance = data.dig('result', 'account_data', 'Balance').to_i
    balance >= amount
  end

  def self.withdraw(user_id, user_address, amount)
    user = User.find(user_id)
    if WithdrawFunds.user_enough_funds?(user, amount)
      if WithdrawFunds.app_enough_funds?(amount)
        RippleClient.submit(account = ENV['ACCOUNT_ADDRESS'], private_key_hex = ENV['PRIVATEKEY'],
                            public_key_hex = ENV['PUBLICKEY'], user_address, amount)
        user.decrement!('balance', amount)
      else
        :app_not_enought_funds
      end
    else
      :user_not_enought_funds
    end
  end
end
