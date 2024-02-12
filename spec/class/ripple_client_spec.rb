require 'rails_helper'

RSpec.describe RippleClient, type: :request do
  context 'class methods' do
    describe '::get_account_transactions' do
      it 'check correct response' do
        account = 'rGEtUv3MGXQi7776hkmi9KfJyH9G7FaBaF'
        VCR.use_cassette 'ripple/response_200_transactions' do
          response = RippleClient.get_account_transactions(account)
          expect(response[0].keys).to eq %w[meta tx validated]
        end
      end
      it 'check bad response' do
        account = '654321'
        VCR.use_cassette 'ripple/wrong_response_transactions' do
          response = RippleClient.get_account_transactions(account)
          expect(response).to eq :wrong_response
        end
      end
    end
    describe '::account_info' do
      it 'check correct response' do
        account = 'rGEtUv3MGXQi7776hkmi9KfJyH9G7FaBaF'
        VCR.use_cassette 'ripple/response_200_account_info' do
          response = RippleClient.account_info(account)
          expect(response.dig('result',
                              'account_data').keys).to eq %w[Account Balance Flags LedgerEntryType OwnerCount PreviousTxnID
                                                             PreviousTxnLgrSeq Sequence index]
        end
      end
      it 'check bad response' do
        account = '343er3'
        VCR.use_cassette 'ripple/wrong_response_account_info' do
          response = RippleClient.account_info(account)
          expect(response.dig('result')['status']).to eq 'error'
        end
      end
    end
    describe '::get_fee' do
      it 'check correct response' do
        VCR.use_cassette 'ripple/get_fee' do
          response = RippleClient.get_fee
          expect(response).to eq 5000
        end
      end
    end
    describe '::submit' do
      it 'check correct response' do
        VCR.use_cassette 'ripple/responce_200_submit' do
          account = 'rEX5oz43exnmJZjjfaVifNy3rqAnuMjFE7'
          pub_key = '8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D3115'
          priv_key = 'BDD78008B47053B24B418FFB31E9F3EAE6F98A4226D2DF6CE51E6EB0D46DEB52'
          destination_account = 'rDMTLGgdYwuCpP385LayLfmB1aknd5LVa'
          amount = 100_000

          response = RippleClient.submit(account, priv_key, pub_key, destination_account, amount)

          expect(response.dig('result')['accepted']).to eq true
        end
      end
      it 'check bad response' do
        VCR.use_cassette 'ripple/wrong_response_submit' do
          account = 'rEX5oz43exnmJZjjfaVifNy3rqAnuMjFE7'
          pub_key = '8F6699A6F95291856711111283A7536D5782748A50DC2D79FDF4997213D3115'
          priv_key = 'BDD71111117053B24B418FFB31E9F3EAE6F98A4226D2DF6CE51E6EB0D46DEB52'
          destination_account = 'rDMTLGgdYwuCpP385LayLfmB1aknd5LVa'
          amount = 100_000

          response = RippleClient.submit(account, priv_key, pub_key, destination_account, amount)

          expect(response.dig('result')['status']).to eq 'error'
        end
      end
    end
  end
end
