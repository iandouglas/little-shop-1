class ChangeDiscountTypeColumnToRole < ActiveRecord::Migration[5.1]
  def change
    rename_column :discounts, :type, :role
  end
end
