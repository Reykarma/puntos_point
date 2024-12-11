class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :admins, :email, unique: true
  end
end
