class ChangeDiscountsDiscountColumnToPercentage < ActiveRecord::Migration[5.1]
  def change
    rename_column :discounts, :discount, :percentage
  end
end
