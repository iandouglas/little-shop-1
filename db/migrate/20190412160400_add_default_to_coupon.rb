class AddDefaultToCoupon < ActiveRecord::Migration[5.1]
  def change
    change_column :coupons, :active, :integer, :default => 0
  end
end
