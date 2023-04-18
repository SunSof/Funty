require 'rails_helper'
require 'uri'

RSpec.describe GoogleAuth, type: :request do
  context 'variable methods' do
    describe '#auth_url' do
      it 'return the google uri' do
        params = {
          client_id: 'vrt404594054jf4',
          redirect_uri: 'https://google.com',
          google_uri: 'https://accounts.google.com/o/oauth2/auth&'
        }
        url = GoogleAuth.new(params).auth_url
        uri = URI.decode_www_form_component(url)

        expect(uri).to include(params[:client_id])
        expect(uri).to include(params[:redirect_uri])
        expect(uri).to include(params[:google_uri])
      end
    end

    describe '#get_user_info', :vcr do
      it 'return :no_code if authorization code is nil' do
        response = GoogleAuth.new.get_user_info(nil)
        expect(response).to eq :no_code
      end

      it 'return :wrong_response if response is not 200..226' do
        response = GoogleAuth.new.get_user_info('jef432vv')
        expect(response).to eq :wrong_response
      end

      it 'return :no_token if id_token not exist' do
        VCR.use_cassette 'vcr/no_token_cassette' do
          response = GoogleAuth.new.get_user_info('4/0AVHEtk43J-i6-dcC8FUjjlyb2blKa2DxeWSu04HBM5FYJZg7f1MwLUQmlpW5ATzgtM3uaQ')
          expect(response).to eq :no_token
        end
      end

      it 'return :invalid_token if id_token not correct' do
        VCR.use_cassette 'vcr/invalid_token_cassette' do
          response = GoogleAuth.new.get_user_info('4/0AVHEtk43J-i6-dcC8FUjjlyb2blKa2DxeWSu04HBM5FYJZg7f1MwLUQmlpW5ATzgtM3uaQ')
          expect(response).to eq :invalid_token
        end
      end

      it 'return email and name if authorization code correct' do
        VCR.use_cassette 'vcr/correct_authorization_cassette' do
          response = GoogleAuth.new.get_user_info('4/0AVHEtk43J-i6-dcC8FUjjlyb2blKa2DxeWSu04HBM5FYJZg7f1MwLUQmlpW5ATzgtM3uaQ')
          expect(response.keys).to eq %i[name email]
        end
      end
    end
  end
end
