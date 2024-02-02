require 'faraday'
require 'ed25519'
require 'base58'
require 'base64'

class RippleClient
  @@sequence_expiration = 2
  @@fee_multiplier = 2
  @@single_sign_code_hex = '53545800'

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

  def self.account_info(account)
    conn = Faraday.new(
      url: ENV['TESTNET_URL'],
      headers: { 'Content-Type' => 'application/json' }
    )

    response = conn.post do |req|
      req.body = {
        method: 'account_info',
        params: [{ account: }]
      }.to_json
    end

    response_data = JSON.parse(response.body)
    if (200..226).member?(response.status) && response_data.present?
      data = { sequence: response_data.dig('result', 'account_data', 'Sequence'),
               ledger_current_index: response_data.dig('result', 'ledger_current_index') }
    else
      :wrong_response
    end
  end

  def self.get_fee
    conn = Faraday.new(
      url: ENV['TESTNET_URL'],
      headers: { 'Content-Type' => 'application/json' }
    )

    response = conn.post do |req|
      req.body = {
        method: 'fee',
        params: [{}]
      }.to_json
    end

    data = JSON.parse(response.body)
    if (200..226).member?(response.status) && data.present?
      data.dig('result', 'drops', 'median_fee').to_i
    else
      :wrong_response
    end
  end

  def self.submit(account, private_key_hex, public_key_hex, destination_account)
    conn = Faraday.new(
      url: ENV['TESTNET_URL'],
      headers: { 'Content-Type' => 'application/json' }
    )
    account_info = RippleClient.account_info(account)
    sequence = account_info[:sequence]
    current_ledget_sequence = account_info[:ledger_current_index]

    fee = @@fee_multiplier * RippleClient.get_fee

    last_ledget_sequence = current_ledget_sequence + @@sequence_expiration
    public_key = 'ED' + public_key_hex

    prep_tx = {
      'Account' => AddressEncoder.to_account_id(account),
      'TransactionType' => 'Payment',
      'Fee' => fee,
      'Sequence' => sequence,
      'LastLedgerSequence' => last_ledget_sequence,
      'SigningPubKey' => public_key,
      'Destination' => AddressEncoder.to_account_id(destination_account),
      'Amount' => 5_000_000
    }
    prep_signature = Serialization.serialize(prep_tx, true)
    single_sign_code_bytes = [@@single_sign_code_hex].pack("H*")
    prep_signature_bytes = [prep_signature].pack("B*")

    signature = Serialization.sign(private_key_hex, single_sign_code_bytes + prep_signature_bytes)

    final_txn = prep_tx.merge({'TxnSignature' => signature})

    tx_blob = Serialization.serialize(final_txn)

    response = conn.post do |req|
      req.body = {
        method: 'submit',
        params: [{ tx_blob: [tx_blob].pack('B*').unpack1('H*').upcase }]
      }.to_json
    end

    data = JSON.parse(response.body)
    if (200..226).member?(response.status) && data.present?
      data
    else
      :wrong_response
    end
  end
end
