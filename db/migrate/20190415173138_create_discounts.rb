class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :type
      t.float :discount
      t.integer :min_quantity
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
