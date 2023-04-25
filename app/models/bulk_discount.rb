class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoices, through: :items
  validates_presence_of :name
  validates_presence_of :percentage_discounts
  validates_presence_of :quantity_threshold
  def percentage
    self[:percentage_discounts] * 100
  end
end
