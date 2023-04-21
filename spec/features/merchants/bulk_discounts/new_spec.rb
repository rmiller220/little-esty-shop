require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount New Page' do
  before do
    test_data
      @bulk_discount1 = @merchant_1.bulk_discounts.create!(name: "10% Discount off 10 items", percentage_discounts: 0.10, quantity_threshold: 10)
      @bulk_discount2 = @merchant_1.bulk_discounts.create!(name: "20% Discount off 15 items", percentage_discounts: 0.20, quantity_threshold: 15)
      @bulk_discount3 = @merchant_2.bulk_discounts.create!(name: "30% Discount off 20 items", percentage_discounts: 0.30, quantity_threshold: 20)
      @bulk_discount4 = @merchant_2.bulk_discounts.create!(name: "15% Discount off 10 items", percentage_discounts: 0.15, quantity_threshold: 10)

    stub_request(:get, "https://api.unsplash.com/photos/random?client_id=FlgsxiCZm-o34965PDOwh6xVsDINZFbzSwcz0__LKZQ&query=merchant")
      .to_return(status: 200, body: File.read('./spec/fixtures/merchant.json'))
    stub_request(:get, "https://api.unsplash.com/photos/5Fxuo7x-eyg?client_id=aOXB56mTdUD88zHCvISJODxwbTPyRRsOk0rA8Ha-cbc")
      .to_return(status: 200, body: File.read('./spec/fixtures/app_logo.json'))
  end
  describe 'Visit Bulk Discount New Page' do
    it "I see a form to create a new discount" do
      visit new_merchant_bulk_discount_path(@merchant_1)

      expect(page).to have_content("Create a New Discount")
      expect(page).to have_field("Name")
      expect(page).to have_field("Percentage Discounts")
      expect(page).to have_field("Quantity Threshold")
      expect(page).to have_button("Create Discount")
    end

    it "I fill in the form with valid data" do
      visit new_merchant_bulk_discount_path(@merchant_1)

      fill_in "Name", with: "30% Discount off 20 items"
      fill_in "Percentage Discounts", with: 0.30
      fill_in "Quantity Threshold", with: 20

      click_button "Create Discount"
      
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))

      expect(page).to have_content("30% Discount off 20 items")
      expect(page).to have_content("Percentage off: 30.0%")
      expect(page).to have_content("Quantity Threshold: 20")
    end

    it "sad path: I fill in the form with invalid data" do
      visit new_merchant_bulk_discount_path(@merchant_1)

      fill_in "Name", with: "30% Discount off 20 items"

      click_button "Create Discount"

      expect(page).to have_content("Please fill out information fields properly")
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
    end
  end
end