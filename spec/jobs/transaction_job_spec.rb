require 'rails_helper'

describe TransactionJob, type: :job do
  it 'is check TransactionJob queue' do
    VCR.use_cassette 'ripple/transaction' do
      expect { TransactionJob.perform_async }.to change(Sidekiq::Queues['default'], :size).by(1)
    end
  end
end
