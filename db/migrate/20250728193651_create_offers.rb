class CreateOffers < ActiveRecord::Migration[8.0]
  def change
    create_table :offers do |t|
      t.string :code
      t.string :description
      t.string :offer_type
      t.jsonb :metadata

      t.timestamps
    end

    add_index :offers, :code, unique: true
    add_index :offers, :offer_type
  end
end
