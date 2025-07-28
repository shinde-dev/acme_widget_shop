class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :code
      t.decimal :price

      t.timestamps
    end

    add_index :products, :code, unique: true
  end
end
