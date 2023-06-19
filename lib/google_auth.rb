require 'uri'
require 'faraday'
require 'json'
require 'jwt'

class GoogleAuth
  def initialize(params = {})
    @client_id = params[:client_id] || ENV['GOOGLE_CLIENT_ID']
    @client_secret = params[:client_secret] || ENV['GOOGLE_CLIENT_SECRET']
    @redirect_uri = params[:redirect_uri] || ENV['REDIRECT_URI']
    @google_uri = params[:google_uri] || 'https://accounts.google.com/o/oauth2/auth?'
    @token_uri = params[:token_uri] || 'https://oauth2.googleapis.com/token'
  end

  def auth_url
    uri = URI(@google_uri)
    params = {
      'client_id' => @client_id,
      'response_type' => 'code',
      'scope' => 'openid',
      'include_granted_scopes' => 'true',
      'access_type' => 'offline',
      'prompt' => 'select_account',
      'redirect_uri' => @redirect_uri
    }

    uri.query = URI.encode_www_form(params)
    uri.to_s
  end

  def get_user_info(param_code)
    return :no_code if param_code.nil?

    params = { 'code' => param_code,
               'client_id' => @client_id,
               'client_secret' => @client_secret,
               'grant_type' => 'authorization_code',
               'redirect_uri' => @redirect_uri }

    response = Faraday.post('https://oauth2.googleapis.com/token', params)
    case response.status
    when 200..226
      data = JSON.parse(response.body)
      token_to_user_info(data['id_token'])
    else
      :wrong_response
    end
  end

  private

  def token_to_user_info(id_token)
    return :no_token unless id_token

    user_info = decrypt_token(id_token)
    return :invalid_token unless user_info

    name = user_info['given_name']
    email = user_info['email']
    return :invalid_params unless name && email

    { name:, email: }
  end

  def decrypt_token(token)
    decoded_token = JWT.decode(token, nil, false)
  rescue JWT::DecodeError
    nil
  else
    decoded_token.first
  end
end
