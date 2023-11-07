class ProcessTransaction
  def self.run(account = ENV['ACCOUNT_ADDRESS'])
    transactions = RippleClient.get_account_transactions(account)
    transactions.each do |transaction|
      hash = transaction.dig('tx', 'hash')
      transaction_result = transaction.dig('meta', 'TransactionResult')
      next unless transaction_result == 'tesSUCCESS' && Transaction.exists?(hash:) == false

      params = {
        hash:,
        amount: transaction.dig('tx', 'Amount'),
        destination_tag: transaction.dig('tx', 'DestinationTag')
      }
      new_transaction = Transaction.create!(params)
      token = new_transaction.destination_tag
      amount = new_transaction.amount
      user = User.find_by(token:)
      next unless user.present?

      user.increment('balance', amount).save!
    end
  end
end
