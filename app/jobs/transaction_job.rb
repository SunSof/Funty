class TransactionJob
  include Sidekiq::Job

  def perform(*_args)
    ProcessTransaction.run
  end
end
