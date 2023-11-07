require 'faraday'

class RippleClient
  def self.get_account_transactions(account)
    conn = Faraday.new(
      url: ENV['TESTNET_URL'],
      headers: { 'Content-Type' => 'application/json' }
    )

    response = conn.post do |req|
      req.body = {
        method: 'account_tx',
        params: [{ account: }]
      }.to_json
    end

    transactions = JSON.parse(response.body).dig('result', 'transactions')
    if (200..226).member?(response.status) && transactions.present?
      transactions
    else
      :wrong_response
    end
  end
end
