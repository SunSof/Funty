class TransactionJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    ProcessTransaction.run
  end
end
