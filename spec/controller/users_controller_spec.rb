require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'google_callback' do
    let(:user_data) do
      {
        'access_token' => 'ya29.a0AWY7CkmmPIUyo4upifvcCqfUBwHVDvvJnl_o06IW0XPvNDvsHccovwXKgD40DPc5wZJLG33ZDKCBE5piIOqjrDtDecbStBQwWRYNmmvKi5-T6gpyfbMYns3U0PgwMAdFXQJuoDhKOE85L-kbUGTUaCgYKAU4SARESFQG1tDrp-ZYZt5AZuBcAihw0lwO4-A0166',
        'expires_in' => 3599,
        'scope' => 'openid https://www.googleapis.com/auth/drive.file https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile',
        'token_type' => 'Bearer',
        'id_token' => 'eyJhbGciOiJSUzI1NiIsImtpZCI6Ijg1YmE5MzEzZmQ3YTdkNGFmYTg0ODg0YWJjYzg0MDMwMDQzNjMxODAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMDI4NTgxNjU3MDUtMzhidWFjZXV1NHByZG5sa3ZkbHU4djJnZW9ndm9oNGEuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIzMDI4NTgxNjU3MDUtMzhidWFjZXV1NHByZG5sa3ZkbHU4djJnZW9ndm9oNGEuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDY1MTE0Nzk3NzA5MTU1MzQ4NzAiLCJlbWFpbCI6ImJ1a2V0b3Zhc29maUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6ImxqUjI3aVB5WlZJT3JEMU85ZVJxbFEiLCJuYW1lIjoi0KHQvtGE0YzRjyDQkdGD0LrQtdGC0L7QstCwIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FBY0hUdGRUM1h4Tko1TkhXbFR2QmdUMks4bThhdng1dHE1UGx3ZFRrVmhVPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6ItCh0L7RhNGM0Y8iLCJmYW1pbHlfbmFtZSI6ItCR0YPQutC10YLQvtCy0LAiLCJsb2NhbGUiOiJydSIsImlhdCI6MTY4NjMzMzcwNywiZXhwIjoxNjg2MzM3MzA3fQ.cZck3aeURFPU0s8w0a1nlZgCOFauRs5MeWakz7nVjI63g46sambWr2rrRAL-cC3bDR2I7iyqFUvuKurxuqNEyCX7HWJzu4gfr4oQ32jnCtgCSBwT6oy3x-7HjIWNfOQU8E1alZKW0fKxWCicTxTL-YfmHhkYH6aZ0bI232dK2DfQS_KirWxcOiHbfj2lST-hiHZZuTcSdYDNQfhaExdIeEUidhiIxHR6qXy4aBSkZUc1uaLnQqGyH5UlW6YgnTi7MHD3o9dG7ZRk7gFadX5Q26KBA9zQhZMSFx-A_YRaAp61Inx_hzwmgfYsuEtHfccyI2eSGaAGVEDcgUILnh9w_g'
      }
    end
    let(:parameters) do
      {
        code: '4/0AbUR2VPtUT33rL5iXtNAzUzM1_r1JVmfwDmktJwQXLltQVHkh6sw5w6p1KSaeZdoDt_MBA',
        client_id: '308v2geogvoh4a.apps.googleusercontent.com',
        client_secret: 'GOCSPX-MlDcfOj5pVca8F8airs',
        grant_type: 'authorization_code',
        redirect_uri: 'https://be49-88-230-7-31.ngrok-free.app/google_auth/google-callback'
      }
    end
    before do
      stub = stub_request(:post, 'https://oauth2.googleapis.com/token').with(body: {
                                                                               code: '4/0AbUR2VPtUT33rL5iXtNAzUzM1_r1JVmfwDmktJwQXLltQVHkh6sw5w6p1KSaeZdoDt_MBA',
                                                                               client_id: nil,
                                                                               client_secret: nil,
                                                                               grant_type: 'authorization_code',
                                                                               redirect_uri: nil
                                                                             }).to_return(status: 200, body: user_data.to_json, headers: {})
    end
    it 'if user create return true' do
      VCR.use_cassette 'vcr/correct_authorization_cassette' do
        exist_user = FactoryBot.create(:user)
        get :google_callback, params: parameters
        expect(User.all.include?(exist_user)).to eq true
      end
    end
  end
end
