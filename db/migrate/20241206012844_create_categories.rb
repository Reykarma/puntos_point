class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false, unique: true
      t.text :description
      t.references :created_by, null: false, foreign_key: { to_table: :admins }

      t.timestamps
    end
    add_index :categories, :name, unique: true
  end
end
