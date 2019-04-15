class Rating < ApplicationRecord
  belongs_to :item
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :description
  validates_numericality_of :rating, {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5}
end
