class WithdrawJob
  include Sidekiq::Job

  def perform(user_id)
    WithdrawFunds.withdraw(user_id)
  end
end
