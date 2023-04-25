require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index Page' do
  before do
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
    stub_request(:get, "https://api.unsplash.com/photos/random?client_id=FlgsxiCZm-o34965PDOwh6xVsDINZFbzSwcz0__LKZQ&query=merchant")
      .to_return(status: 200, body: File.read('./spec/fixtures/merchant.json'))
    stub_request(:get, "https://api.unsplash.com/photos/5Fxuo7x-eyg?client_id=aOXB56mTdUD88zHCvISJODxwbTPyRRsOk0rA8Ha-cbc")
      .to_return(status: 200, body: File.read('./spec/fixtures/app_logo.json'))
    stub_request(:get, "https://date.nager.at/api/v3/NextPublicHolidays/US")
      .to_return(status: 200, body: File.read('./spec/fixtures/holidays.json'))
  end
  describe 'Visit Bulk Discounts Index Page' do
    it "I see a link to all my discounts" do
      visit merchant_bulk_discounts_path(@merchant_1)

      expect(page).to have_content("Bulk Index Page")
      expect(page).to have_link(@bulk_discount1.name)
      expect(page).to have_content("Percentage off: 10.0%")
      expect(page).to have_content("Quantity Threshold: 10")
      expect(page).to have_link(@bulk_discount1.name)
      expect(page).to have_content("Percentage off: 20.0%")
      expect(page).to have_content("Quantity Threshold: 15")

    end

    it "I click link to show page" do
      visit merchant_bulk_discounts_path(@merchant_1)

      click_link(@bulk_discount1.name)

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @bulk_discount1))

      expect(page).to have_content(@bulk_discount1.name)
      expect(page).to have_content("Percentage off: 10.0%")
      expect(page).to have_content("Quantity Threshold: 10")
    end

    it "I see a link to create a new discount" do
      visit merchant_bulk_discounts_path(@merchant_1)

      expect(page).to have_link("Create New Discount")

      click_link("Create New Discount")

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
    end
      
    it "I see a link to delete each discount" do
      visit merchant_bulk_discounts_path(@merchant_1)

      expect(page).to have_link("Delete Discount")

      click_link("Delete Discount #{@bulk_discount1.id}")

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      expect(page).to_not have_content(@bulk_discount1.name)
    end

    it "I see a link to edit each discount" do
      visit merchant_bulk_discounts_path(@merchant_1)

      expect(page).to have_link("Edit Discount #{@bulk_discount1.id}")
    end

    it "I click link to edit page" do
      visit merchant_bulk_discounts_path(@merchant_1)

      click_link("Edit Discount #{@bulk_discount1.id}")
      
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount1))
      expect(page).to have_content("Edit #{@bulk_discount1.name}")
      expect(page).to have_content("Percentage off:")
      expect(page).to have_content("Quantity Threshold:")
      expect(page).to have_field("Name")
      expect(page).to have_field("Percentage off:")
      expect(page).to have_field("Quantity Threshold:")
      expect(page).to have_button("Update Discount")
    end

    it "I can edit a discount" do
      visit edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount1)

      fill_in "Name", with: "50% Discount off 50 items"
      fill_in "Percentage off:", with: 0.50
      fill_in "Quantity Threshold:", with: 50
      click_button("Update Discount")

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @bulk_discount1))

      expect(page).to have_content("50% Discount off 50 items")
      expect(page).to have_content("Percentage off: 50.0%")
      expect(page).to have_content("Quantity Threshold: 50")
    end

    it "Sad path: I cannot edit a discount with missing fields" do
      visit edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount1)

      fill_in "Name", with: ""
      click_button("Update Discount")

      expect(page).to have_content("Please fill out information fields properly")
    end

    it 'I see a section with a header of "Upcoming Holidays"' do
      @holidays = HolidayBuilder.holidays
      visit merchant_bulk_discounts_path(@merchant_1)

      expect(page).to have_content("Upcoming Holidays")
      expect(page).to have_content(@holidays.name1)
      expect(page).to have_content(@holidays.date1)
      expect(page).to have_content(@holidays.name2)
      expect(page).to have_content(@holidays.date2)
      expect(page).to have_content(@holidays.name3)
      expect(page).to have_content(@holidays.date3)
    end
  end
end

# 9: Holidays API

# As a merchant
# When I visit the discounts index page
# I see a section with a header of "Upcoming Holidays"
# In this section the name and date of the next 3 upcoming US holidays are listed.

# Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)

# 5: Merchant Bulk Discount Edit

# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated
