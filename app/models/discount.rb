class Discount < ApplicationRecord
  belongs_to :item

  validates_presence_of :percentage,
                        :min_quantity,
                        :item_id

  def view_percentage
    (percentage * 100).to_i
  end
end
