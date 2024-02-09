class WithdrawFunds
  def self.user_enough_funds?(user, amount)
    user.balance >= amount
  end

  def self.app_enough_funds?(account = ENV['ACCOUNT_ADDRESS'], amount)
    data = RippleClient.account_info(account)
    balance = data.dig('result', 'account_data', 'Balance').to_i
    balance >= amount
  end

  def self.withdraw(user_id)
    user = User.find(user_id)
    data = eval($redis.get("withdraw_#{user_id}")).first
    user_wallet = data[:user_wallet]
    amount = data[:withdrawal_amount].to_i
    if WithdrawFunds.user_enough_funds?(user, amount)
      if WithdrawFunds.app_enough_funds?(amount)
        RippleClient.submit(account = ENV['ACCOUNT_ADDRESS'], private_key_hex = ENV['PRIVATEKEY'],
                            public_key_hex = ENV['PUBLICKEY'], user_wallet, amount)
        user.decrement!('balance', amount)
        $redis.del("withdraw_#{user_id}")
      else
        :app_not_enought_funds
      end
    else
      :user_not_enought_funds
    end
  end
end
