class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  belongs_to :customer
  has_one :merchant, through: :items
  has_many :bulk_discounts, through: :merchant

  enum status: ["cancelled", "in progress", "completed"]
  
  def total_revenue
    invoice_items.sum('quantity * unit_price') / 100.0
  end

  def self.incomplete_invoices
    joins(:invoice_items, :items).where.not("invoice_items.status = 2").distinct.order(:created_at)
  end

  def total_bulk_discount
    invoice_items
      .joins(:bulk_discounts)
      .where("bulk_discounts.quantity_threshold <= invoice_items.quantity")
      .group("invoice_items.id")
      .select('MAX(invoice_items.quantity * invoice_items.unit_price * bulk_discounts.percentage_discounts / 100) AS discount')
      .sum(&:discount)
  end

  def total_discounted_revenue
    total_revenue - total_bulk_discount
  end
end
