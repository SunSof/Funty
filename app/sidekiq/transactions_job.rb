class TransactionsJob
  include Sidekiq::Job

  def perform(*args); end
end
