require 'rails_helper'

describe WithdrawJob, type: :job do
  it 'is check WithdrawJob queue' do
    expect { WithdrawJob.perform_async }.to change(Sidekiq::Queues['default'], :size).by(1)
  end
end
