class ProcessTransaction
  def self.run(account = ENV['ACCOUNT_ADDRESS'])
    transactions = RippleClient.get_account_transactions(account)
<<<<<<< withdraw_funds
    if transactions != :wrong_response
      transactions.each do |transaction|
        tx_hash = transaction.dig('tx', 'hash')
        transaction_result = transaction.dig('meta', 'TransactionResult')
        next unless transaction_result == 'tesSUCCESS' && Transaction.exists?(tx_hash:) == false

        params = {
          tx_hash:,
          amount: transaction.dig('tx', 'Amount'),
          destination_tag: transaction.dig('tx', 'DestinationTag')
        }
        new_transaction = Transaction.create!(params)
        token = new_transaction.destination_tag
        amount = new_transaction.amount
        user = User.find_by(token:)
        next unless user.present?
=======
    transactions.each do |transaction|
      tx_hash = transaction.dig('tx', 'hash')
      transaction_result = transaction.dig('meta', 'TransactionResult')
      next unless transaction_result == 'tesSUCCESS' && Transaction.exists?(tx_hash:) == false

      params = {
        tx_hash:,
        amount: transaction.dig('tx', 'Amount'),
        destination_tag: transaction.dig('tx', 'DestinationTag')
      }
      new_transaction = Transaction.create!(params)
      token = new_transaction.destination_tag
      amount = new_transaction.amount
      user = User.find_by(token:)
      next unless user.present?
>>>>>>> main

        user.increment('balance', amount/100).save!
      end
    end
  end
end
