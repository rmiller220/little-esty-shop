require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page' do
  before (:each) do
    stub_request(:get, "https://api.unsplash.com/photos/random?client_id=FlgsxiCZm-o34965PDOwh6xVsDINZFbzSwcz0__LKZQ&query=merchant")
      .to_return(status: 200, body: File.read('./spec/fixtures/merchant.json'))
    stub_request(:get, "https://api.unsplash.com/photos/5Fxuo7x-eyg?client_id=aOXB56mTdUD88zHCvISJODxwbTPyRRsOk0rA8Ha-cbc")
      .to_return(status: 200, body: File.read('./spec/fixtures/app_logo.json'))
  end

  describe 'User Story 32' do 
    before do 
      test_data
    end
    it 'can visit the admin invoice show page' do
      visit admin_invoice_path(@invoice_1)
    end

    it 'I see information related to that invoice(invoice id, status, invoice created_at, and customer name)' do
      visit admin_invoice_path(@invoice_1)

      within("#invoice_details") do
        expect(page).to have_content(@invoice_1.id)
        expect(page).to have_content(@invoice_1.status)
        expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(@customer_1.first_name)
        expect(page).to have_content(@customer_1.last_name)
      end 

      visit admin_invoice_path(@invoice_2)

      within("#invoice_details") do
        expect(page).to have_content(@invoice_2.id)
        expect(page).to have_content(@invoice_2.status)
        expect(page).to have_content(@invoice_2.created_at.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(@customer_1.first_name)
        expect(page).to have_content(@customer_1.last_name)
      end
    end
  end


  describe 'User Story 34' do
    before do 
      test_data
    end
    it 'I see the information for all relevant items' do
      visit admin_invoice_path(@invoice_1)
     
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content(@invoice_item_1.price_usd)
      expect(page).to have_content(@invoice_item_1.status)
    end
  end

  describe 'User Story 35' do
    before do
      test_data
    end
    it 'I see the total revenue that will be generated from this invoice' do
      visit admin_invoice_path(@invoice_1)

      within("#invoice_details") do
        expect(page).to have_content(@invoice_1.total_revenue)
      end

      visit admin_invoice_path(@invoice_2)

      within("#invoice_details") do
        expect(page).to have_content(@invoice_2.total_revenue)
      end
    end
  end

  describe 'User Story 36' do
    before do
      test_data
    end
    it 'I see the invoice status is a select field' do
      visit admin_invoice_path(@invoice_1)

      within "#invoice_details" do
        expect(page).to have_select('invoice_status', selected: 'in progress')
      end
    end

    it 'I can update the invoice status' do
      visit admin_invoice_path(@invoice_1)

        within "#invoice-status" do
          select 'completed', from: 'invoice_status'
          click_button 'Update Status'
        end

      @invoice_1.reload
      expect(@invoice_1.status).to eq('completed')
      expect(current_path).to eq(admin_invoice_path(@invoice_1))
    end
  end

  describe "admin invoice show page: total revenue and discounted revenue" do
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

    it "shows the total revenue from this invoice (not including discounts)" do
      visit admin_invoice_path(@invoice_1)

      expect(page).to have_content(@invoice_1.total_revenue)

      visit admin_invoice_path(@invoice_2)

      expect(page).to have_content(@invoice_2.total_revenue)
    end

    it "shows the total discounted revenue from this invoice which includes 
        bulk discounts in the calculation" do
      visit admin_invoice_path(@invoice_1)

      expect(page).to have_content("$#{@invoice_1.total_discounted_revenue}")

      visit admin_invoice_path(@invoice_2)

      expect(page).to have_content("$#{@invoice_2.total_discounted_revenue}")
    end
  end
end
