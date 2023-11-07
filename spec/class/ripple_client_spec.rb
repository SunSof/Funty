require 'rails_helper'

RSpec.describe RippleClient, type: :request do
  context 'class methods' do
    describe '::get_account_transactions' do
      it 'check correct response' do
        account = 'rGEtUv3MGXQi7776hkmi9KfJyH9G7FaBaF'
        VCR.use_cassette 'ripple/response_200' do
          response = RippleClient.get_account_transactions(account)
          expect(response[0].keys).to eq %w[meta tx validated]
        end
      end
      it 'check bad response' do
        account = '654321'
        link = 'https://s.altnet.rippletest.net'
        VCR.use_cassette 'ripple/bad_response' do
          response = RippleClient.get_account_transactions(account)
          expect(response).to eq :wrong_response
        end
      end
    end
  end
end
