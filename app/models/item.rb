class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :bulk_discounts, through: :merchant

  enum status: { disabled: 0, enabled: 1}

  scope :enabled_items, -> { where(status: 1) }
  scope :disabled_items, -> { where(status: 0) }
  
  def self.top_five_items
    Item.select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS product")
    .joins(:transactions)
    .where("transactions.result = 1")
    .group("items.id")
    .order(product: :desc)
    .limit(5)
  end

  def top_day
  invoices.joins(:invoice_items, :transactions)
          .where('transactions.result = 1')
          .select('invoices.*, invoice_items.quantity as sales')
          .group('invoices.id, invoices.created_at, sales')
          .order(sales: :desc)
          .first.created_at.strftime("%m/%d/%Y")
  end
end