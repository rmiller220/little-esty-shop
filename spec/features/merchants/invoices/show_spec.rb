require 'rails_helper'

RSpec.describe 'Merchant Invoice Show Page' do
  before(:each) do
    # test_data
    stub_request(:get, "https://api.unsplash.com/photos/random?client_id=FlgsxiCZm-o34965PDOwh6xVsDINZFbzSwcz0__LKZQ&query=merchant")
      .to_return(status: 200, body: File.read('./spec/fixtures/merchant.json'))
    stub_request(:get, "https://api.unsplash.com/photos/5Fxuo7x-eyg?client_id=aOXB56mTdUD88zHCvISJODxwbTPyRRsOk0rA8Ha-cbc")
      .to_return(status: 200, body: File.read('./spec/fixtures/app_logo.json'))
  end

  describe 'User Story 15' do 
    before do
      test_data
    end
    it 'I see information related to that invoice(Invoice ID, Status, Created Date, Customer Name)' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      expect(page).to have_content(@invoice_1.id)
      within '#invoice_info' do
        expect(page).to have_content(@invoice_1.status)
        expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(@customer_1.first_name)
        expect(page).to have_content(@customer_1.last_name)
      end

      visit merchant_invoice_path(@merchant_2, @invoice_7)
      expect(page).to have_content(@invoice_7.id)

      within'#invoice_info' do
        expect(page).to have_content(@invoice_7.status)
        expect(page).to have_content(@invoice_7.created_at.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(@customer_3.first_name)
        expect(page).to have_content(@customer_3.last_name)
      end
    end
  end

  describe 'User Story 16' do
    before do
      test_data
    end
    it 'Then I see all of my items on the invoice (Item Name, Invoice Item Quantity, Invoice Item Price, Invoice Item Status)' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within '#items_table' do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@invoice_item_1.quantity)
        expect(page).to have_content(@invoice_item_1.unit_price)

        expect(page).to have_content(@item_7.name)
        expect(page).to have_content(@invoice_item_7.quantity)
        expect(page).to have_content(@invoice_item_7.unit_price)
      end

      visit merchant_invoice_path(@merchant_2, @invoice_7)

      within '#items_table' do
        expect(page).to have_content(@item_14.name)
        expect(page).to have_content(@invoice_item_27.quantity)
        expect(page).to have_content(@invoice_item_27.unit_price)
      end
    end
  end

  describe 'User Story 17' do
    before do
      test_data
    end
    it 'I see the total revenue that will be generated from this invoice' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)
    
      within "#invoice_info" do
        expect(page).to have_content(@invoice_1.total_revenue)
      end

      visit merchant_invoice_path(@merchant_2, @invoice_7)
      
      within "#invoice_info" do
        expect(page).to have_content(@invoice_7.total_revenue)
      end
    end
  end

  describe 'User Story 18' do
    before do
      test_data
    end
    it 'I see that the invoice status is a select field' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)
      
      within "#items_table" do
        expect(page).to have_select('invoice_item_status')
        expect(page).to have_button('Update Status')
      end
    end
    
    it 'I can update the invoice item status' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)
      
      within "#item-#{@invoice_item_1.id}-status" do
        select 'Shipped', from: 'invoice_item_status'
        click_button 'Update Status'
      end

      @invoice_item_1.reload

      expect(@invoice_item_1.status).to eq('shipped')
      expect(current_path).to eq(merchant_invoice_path(@merchant_1, @invoice_1))

      within "#item-#{@invoice_item_21.id}-status" do
        select 'Pending', from: 'invoice_item_status'
        click_button 'Update Status'
      end

      @invoice_item_21.reload
      
      expect(@invoice_item_21.status).to eq('pending')
      expect(current_path).to eq(merchant_invoice_path(@merchant_1, @invoice_1))
    end
    
    it 'I see the total revenue for this invoice, without the discounts' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within "#invoice_info" do
        expect(page).to have_content(@invoice_1.total_revenue)
      end

      visit merchant_invoice_path(@merchant_2, @invoice_7)

      within "#invoice_info" do
        expect(page).to have_content(@invoice_7.total_revenue)
      end
    end
    describe 'user story 6' do
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
        it 'I see the total discounted revenue for this invoice, which 
        includes bulk discounts in the calculation' do
          visit merchant_invoice_path(@merchant_1, @invoice_1)
          save_and_open_page
          within "#invoice_info" do
          expect(page).to have_content("Total Discounted Revenue: #{@invoice_1.total_discounted_revenue}")
        end
        
        visit merchant_invoice_path(@merchant_2, @invoice_5)
        
        within "#invoice_info" do
        expect(page).to have_content("Total Discounted Revenue: #{@invoice_5.total_discounted_revenue}")
        end
      end
    end
  end
end

# 6: Merchant Invoice Show Page: Total Revenue and Discounted Revenue

# As a merchant
# When I visit my merchant invoice show page
# Then I see the total revenue for my merchant from this invoice (not including discounts)
# And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation