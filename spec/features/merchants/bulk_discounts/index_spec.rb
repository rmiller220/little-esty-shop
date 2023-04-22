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
  end
end


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
