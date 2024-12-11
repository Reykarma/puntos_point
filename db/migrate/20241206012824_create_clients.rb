class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :clients, :email, unique: true
  end
end
