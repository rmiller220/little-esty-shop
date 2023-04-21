require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index Page' do
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

      visit merchant_bulk_discounts_path(@merchant_1, @bulk_discount2)

      expect(page).to have_content(@bulk_discount2.name)
      expect(page).to have_content("Percentage off: 20.0%")
      expect(page).to have_content("Quantity Threshold: 15")
    end

    it "I see a link to delete each discount" do
      visit merchant_bulk_discounts_path(@merchant_1)

      expect(page).to have_link("Delete Discount")

      click_link("Delete Discount")

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      expect(page).to_not have_content(@bulk_discount1.name)

    end
  end
end

# 1: Merchant Bulk Discounts Index

# As a merchant
# When I visit my merchant dashboard
# Then I see a link to view all my discounts
# When I click this link
# Then I am taken to my bulk discounts index page
# Where I see all of my bulk discounts including their
# percentage discount and quantity thresholds
# And each bulk discount listed includes a link to its show page