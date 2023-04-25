class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoices
  has_many :bulk_discounts, through: :item
  enum status: ["pending", "packaged", "shipped"]

  def self.not_yet_shipped
    joins(:invoice).where.not(status: 2).order('invoices.created_at')
  end

  def item_name
    item.name
  end

  def price_usd
    unit_price / 100.0
  end

  def discount_applied
    bulk_discounts
    .where("quantity_threshold <= ?", quantity)
    .order(:percentage_discounts)
    .last
  end
end