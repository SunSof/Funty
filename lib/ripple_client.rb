require 'faraday'
require 'ed25519'
require 'base58'
require 'base64'

class RippleClient
  @@sequence_expiration = 2
  @@fee_multiplier = 2
  @@single_sign_code_hex = '53545800'
  @@single_sign_code = '01010011010101000101100000000000'

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
    prep_signature = Serialization.serialize(prep_tx, signature_mode: true) # полностью совпадает .pack('H*')
    message = @@single_sign_code + prep_signature # message ok
    sign = [message].pack('B*').unpack1('H*')

    signature = Serialization.sign(private_key_hex, public_key_hex, sign)
    # keypair = [private_key_hex + public_key_hex].pack('H*')
    # signing_key = Ed25519::SigningKey.from_keypair(keypair)
    # signature = signing_key.sign(sign).unpack1('H*')

    # p signature

    prep_tx['TxnSignature'] = signature

    tx_blob = Serialization.serialize(prep_tx)

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
# el "1200002402A02CD7201B02AE6AD06140000000004C4B406840000000000027107321ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D3115744047BDD9958DDA7782AA773E396DB03AE3B4ADC1AE96A9B61826E9E93760F917F3E3C93C921E3B669868DB356D7BC8896121F67A814EABC8CE074060B08EB2BB0881149F612424D5DF9351F9872176B50DD3C78DE50A958314025610D0B151DCFD648EF2B0BD06D730F3FCA489"
# ru "1200002402A02CDD201B02AECE956140000000004C4B406840000000000027107321ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D31157440C6EDDF1F983517534905693FC9EC787630EB76E67899EA7FBC6A53FEB1DF8B68F2FB68476762AB0E9F23946A558A157FFEF78B8C947A73253637C4F326D3C70C81149F612424D5DF9351F9872176B50DD3C78DE50A958314025610D0B151DCFD648EF2B0BD06D730F3FCA489"

# "1200002402A02CDF201B02AECF246140000000004C4B406840000000000027107321ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D311581149F612424D5DF9351F9872176B50DD3C78DE50A958314025610D0B151DCFD648EF2B0BD06D730F3FCA489"
# "1200002402A02CE0201B02AECF366140000000004C4B406840000000000027107321ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D311581149F612424D5DF9351F9872176B50DD3C78DE50A958314025610D0B151DCFD648EF2B0BD06D730F3FCA489"

# "535458001200002402A02CE2201B02AEDA0A6140000000004C4B406840000000000027107321ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D311581149F612424D5DF9351F9872176B50DD3C78DE50A958314025610D0B151DCFD648EF2B0BD06D730F3FCA489"
# "535458001200002402A02CE2201B02AEDA8F6140000000004C4B406840000000000027107321ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D311581149F612424D5DF9351F9872176B50DD3C78DE50A958314025610D0B151DCFD648EF2B0BD06D730F3FCA489"

# "E8633EEFAE01D6D2834DE017E81D2EF7DCE103E59EBE9C5822F339561D572B59CAECDDB490DF60AEE098EFC87AB4D50B07577D2660A3125E0A5F27418D846E0A"
# "E4C501E03AD34FA63F2473DCD4C822B392256794D386B7865EAF3795C056FA5C4873205413D1A65DD4CE5FB1AA170FC4653EC657052EE87149B8F8CE779D0808"
