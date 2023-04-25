require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  
  describe 'relationships' do
    it { should belong_to :invoice}
    it { should belong_to :item}
    it { should have_many(:bulk_discounts).through(:item)}
  end

  
  describe 'class methods' do
    before(:each) do
      test_data
    end
    it '::not_yet_shipped' do 
      expect(@merchant_1.invoice_items.not_yet_shipped.count).to eq(26)

      @invoice_item_25.update!(status: 2)
      @invoice_item_26.update!(status: 2)

      expect(@merchant_1.invoice_items.not_yet_shipped.count).to eq(24)
    end
  end

  describe 'instance methods' do
    before(:each) do
      test_data
    end
    it '#item_name' do
      expect(@invoice_item_1.item_name).to eq(@item_1.name)
    end

    it '#price_usd' do
      expect(@invoice_item_1.price_usd).to eq(@invoice_item_1.unit_price / 100.0)
    end
  end
  describe "instance methods part 2" do
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
      @invoice_item_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_5.id, quantity: 20, unit_price: 400, status: 1)
      @invoice_item_5 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_5.id, quantity: 10, unit_price: 500, status: 1)
      @invoice_item_6 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_6.id, quantity: 5, unit_price: 600, status: 1)
      @transaction_1 = @invoice_1.transactions.create!(credit_card_number: 203942, result: 1)
      @transaction_2 = @invoice_2.transactions.create!(credit_card_number: 230948, result: 1)
      @transaction_3 = @invoice_3.transactions.create!(credit_card_number: 234092, result: 1)
      @transaction_4 = @invoice_4.transactions.create!(credit_card_number: 230429, result: 1)
      @transaction_5 = @invoice_5.transactions.create!(credit_card_number: 102938, result: 1)
      @transaction_6 = @invoice_6.transactions.create!(credit_card_number: 879799, result: 1)
    end
    it "discount_applied" do
      expect(@invoice_item_1.discount_applied).to eq(@bulk_discount1)
      expect(@invoice_item_2.discount_applied).to eq(@bulk_discount2)
      expect(@invoice_item_3.discount_applied).to eq(nil)
      expect(@invoice_item_4.discount_applied).to eq(@bulk_discount3)
      expect(@invoice_item_5.discount_applied).to eq(@bulk_discount4)
      expect(@invoice_item_6.discount_applied).to eq(nil)
    end
  end
end

