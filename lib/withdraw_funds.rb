class WithdrawFunds
  def self.user_balance(user, amount)
    return unless user.balance >= amount

    user.decrement!('balance', amount)
  end

  def self.check_app_balance(account = ENV['ACCOUNT_ADDRESS'])
    data = RippleClient.get_account_info(account)
    data.dig('result', 'account_data', 'Balance').to_i
  end
end
