class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :amount
      t.string :transaction_id
      t.integer :destination_tag

      t.timestamps
    end
  end
end
