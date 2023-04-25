require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer}
    it { should have_many :invoice_items}
    it { should have_many(:items).through(:invoice_items)}
    it { should have_many :transactions }
    it { should have_many(:bulk_discounts).through(:merchant)}
  end

  
  describe '#total_revenue' do
  before(:each) do
    test_data
  end
    it 'can calculate the total revenue of an invoice' do
      expect(@invoice_1.total_revenue).to eq(26.0)
      expect(@invoice_2.total_revenue).to eq(27.0)
    end
  end

describe'::incomplete_invoices' do
  before(:each) do
    test_data
  end
    it 'can find all invoices that have items that have not yet been shipped' do
      expect(Invoice.incomplete_invoices.count).to eq(20)

      @invoice_item_1.update(status: 2)
      @invoice_item_21.update(status: 2)
      @invoice_item_41.update(status: 2)

      expect(Invoice.incomplete_invoices.count).to eq(19)
    end

    it 'can order the invoices by their creation date' do
      expect(Invoice.incomplete_invoices.first.created_at).to be < (Invoice.incomplete_invoices.last.created_at)
    end
  end

  describe '#total_revenue_with_discount' do
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Schroeder-Jerde")
    @merchant_2 = Merchant.create!(name: "James Bond")
    @bulk_discount1 = @merchant_1.bulk_discounts.create!(name: "10% Discount off 10 items", percentage_discounts: 0.10, quantity_threshold: 10, merchant_id: 1)
    @bulk_discount2 = @merchant_1.bulk_discounts.create!(name: "20% Discount off 15 items", percentage_discounts: 0.20, quantity_threshold: 15, merchant_id: 1)
    @bulk_discount3 = @merchant_2.bulk_discounts.create!(name: "30% Discount off 20 items", percentage_discounts: 0.30, quantity_threshold: 20, merchant_id: 2)
    @bulk_discount4 = @merchant_2.bulk_discounts.create!(name: "15% Discount off 10 items", percentage_discounts: 0.15, quantity_threshold: 10, merchant_id: 2)
    @item_1 = @merchant_1.items.create!(name: "Pencil", description: "You can use it to write things", unit_price: 1.00)
    @item_2 = @merchant_1.items.create!(name: "Pen", description: "You can use it to write things", unit_price: 2.00)
    @item_3 = @merchant_1.items.create!(name: "Paper", description: "You can use it to write things", unit_price: 3.00)
    @item_4 = @merchant_1.items.create!(name: "Eraser", description: "You can use it to erase things", unit_price: 4.00)
    @item_5 = @merchant_2.items.create!(name: "Stapler", description: "You can use it to staple things", unit_price: 5.00)
    @item_6 = @merchant_2.items.create!(name: "Tape", description: "You can use it to tape things", unit_price: 6.00)
    @item_7 = @merchant_2.items.create!(name: "Staples", description: "You can use it to staple things", unit_price: 7.00)
    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Stephanie", last_name: "Jones")
    @invoice_1 = @customer_1.invoices.create!(status: 1)
    @invoice_2 = @customer_1.invoices.create!(status: 1)
    @invoice_3 = @customer_1.invoices.create!(status: 1)
    @invoice_4 = @customer_2.invoices.create!(status: 1)
    @invoice_5 = @customer_2.invoices.create!(status: 1)
    @invoice_6 = @customer_2.invoices.create!(status: 1)
    @invoice_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 100, status: 1)
    @invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 15, unit_price: 200, status: 1)
    @invoice_item_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_3.id, quantity: 2, unit_price: 300, status: 1)
    @invoice_item_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 20, unit_price: 400, status: 1)
    @invoice_item_5 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_5.id, quantity: 10, unit_price: 500, status: 1)
    @invoice_item_6 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_6.id, quantity: 5, unit_price: 600, status: 1)
    @transaction_1 = @invoice_1.transactions.create!(credit_card_number: 203942, result: 1)
    @transaction_2 = @invoice_2.transactions.create!(credit_card_number: 230948, result: 1)
    @transaction_3 = @invoice_3.transactions.create!(credit_card_number: 234092, result: 1)
    @transaction_4 = @invoice_4.transactions.create!(credit_card_number: 230429, result: 1)
    @transaction_5 = @invoice_5.transactions.create!(credit_card_number: 102938, result: 1)
    @transaction_6 = @invoice_6.transactions.create!(credit_card_number: 879799, result: 1)

  end
  # to test multiple discounts on a single item, remove invoice 2,
  #  make invoice_item_2 be associated with invoice_1, then add numbers
  # from invoice_2 to invoice_1
    it 'total_bulk_discount' do
      expect(@invoice_1.total_bulk_discount).to eq(1.0)
      expect(@invoice_2.total_bulk_discount).to eq(6.0)
      expect(@invoice_3.total_bulk_discount).to eq(0.0)
      expect(@invoice_4.total_bulk_discount).to eq(16.0)
      expect(@invoice_5.total_bulk_discount).to eq(7.5)
      expect(@invoice_6.total_bulk_discount).to eq(0.0)
    end

    it 'total_discounted_revenue' do
      expect(@invoice_1.total_discounted_revenue).to eq(9.0)
      expect(@invoice_2.total_discounted_revenue).to eq(24.0)
      expect(@invoice_3.total_discounted_revenue).to eq(6.0)
      expect(@invoice_4.total_discounted_revenue).to eq(64.0)
      expect(@invoice_5.total_discounted_revenue).to eq(42.5)
      expect(@invoice_6.total_discounted_revenue).to eq(30.0)
    end
  end
end