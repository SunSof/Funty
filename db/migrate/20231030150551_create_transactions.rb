class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: false do |t|
      t.primary_key :date_id, limit: 8
      t.bigint :amount, null: false
      t.integer :destination_tag

      t.timestamps
    end
  end
end
