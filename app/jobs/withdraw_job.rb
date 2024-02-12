class WithdrawJob
  include Sidekiq::Job

  def perform(user_id, user_address, amount)
    WithdrawFunds.withdraw(user_id, user_address, amount)
  end
end
