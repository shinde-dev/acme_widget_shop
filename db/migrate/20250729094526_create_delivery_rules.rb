class CreateDeliveryRules < ActiveRecord::Migration[8.0]
  def change
    create_table :delivery_rules do |t|
      t.decimal :min_total, null: false
      t.decimal :max_total
      t.decimal :charge, null: false

      t.timestamps
    end
  end
end
