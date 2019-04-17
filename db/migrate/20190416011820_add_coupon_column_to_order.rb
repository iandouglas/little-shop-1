class AddCouponColumnToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :coupon_id, :integer
  end
end
