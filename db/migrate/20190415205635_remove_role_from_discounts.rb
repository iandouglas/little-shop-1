class RemoveRoleFromDiscounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :discounts, :role, :integer
  end
end
