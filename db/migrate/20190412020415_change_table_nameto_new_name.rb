class ChangeTableNametoNewName < ActiveRecord::Migration[5.1]
  def change
    rename_table :coubons, :coupons
  end
end
