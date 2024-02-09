class WithdrawJob
  include Sidekiq::Job

  def perform(user_id, user_wallet, amount)
    WithdrawFunds.withdraw(user_id, user_wallet, amount)
  end
end
