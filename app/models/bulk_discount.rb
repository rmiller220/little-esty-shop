class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant

  def percentage
    self[:percentage_discounts] * 100
  end
end
