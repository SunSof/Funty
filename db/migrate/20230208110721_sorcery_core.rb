class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :winnings, default: 0
      t.integer :losses, default: 0
      t.integer :balance, default: 0
      t.integer :token, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt

      t.timestamps null: false
    end
  end
end
