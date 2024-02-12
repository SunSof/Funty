class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: false do |t|
      t.string :tx_hash, null: false, primary_key: true
      t.bigint :amount, null: false
      t.integer :destination_tag

      t.timestamps
    end
  end
end
