class CreatePurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :purchases do |t|
      t.references :client, null: false
      t.references :product, null: false
      t.integer :quantity, null: false, default: 1
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.datetime :purchased_at, null: false

      t.timestamps
    end
  end
end
