class AddCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coubons do |t|
      t.string :name
      t.integer :discount
      t.integer :amount
      t.integer :active

      t.timestamps
    end
  end
end
