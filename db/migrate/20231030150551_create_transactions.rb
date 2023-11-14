class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: false do |t|
      t.primary_key :hash
      t.integer :amount, null: false
      t.integer :destination_tag

      t.timestamps
    end
  end
end
