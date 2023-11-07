class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.bigint :hash, options: 'PRIMARY KEY'
      t.integer :amount, null: false
      t.integer :destination_tag

      t.timestamps, null: false
    end
  end
end
