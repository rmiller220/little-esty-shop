require 'rails_helper'

RSpec.describe "admin/merchants index", type: :feature do
  describe "display" do
    before do
      test_data
    end
    
    it "displays all merchants" do
      visit admin_merchants_path
      
      expect(page).to have_content(@merchant_1.name)
      expect(page).to have_content(@merchant_2.name)
      expect(page).to have_content(@merchant_3.name)
      expect(page).to have_content(@merchant_4.name)
      expect(page).to have_content(@merchant_5.name)
      expect(page).to have_content(@merchant_6.name)
    end

    it "has links to merchant show pages" do
      visit admin_merchants_path
      
      expect(page).to have_link(@merchant_1.name, href: admin_merchant_path(@merchant_1))
      expect(page).to have_link(@merchant_2.name, href: admin_merchant_path(@merchant_2))
      expect(page).to have_link(@merchant_3.name, href: admin_merchant_path(@merchant_3))
      expect(page).to have_link(@merchant_4.name, href: admin_merchant_path(@merchant_4))
      expect(page).to have_link(@merchant_5.name, href: admin_merchant_path(@merchant_5))
      expect(page).to have_link(@merchant_6.name, href: admin_merchant_path(@merchant_6))
    end
  end

  describe "functionality" do 
    before do
      test_data
    end

    it "links to show pages are functional" do
      visit admin_merchants_path

      click_link(@merchant_1.name)
      expect(current_path).to eq(admin_merchant_path(@merchant_1))

      visit admin_merchants_path

      click_link(@merchant_2.name)
      expect(current_path).to eq(admin_merchant_path(@merchant_2))
    end

    it "has buttons to enable/disable merchants" do
      visit admin_merchants_path 

      expect(page.all(:button, "Enable").count).to eq(6)
    end

    it "enable/disable buttons are functional" do
      visit admin_merchants_path

      expect(@merchant_1.status).to eq("disabled")

      click_button("enable_#{@merchant_1.id}")
      expect(current_path).to eq(admin_merchants_path)
      expect(@merchant_1.status).to eq("disabled")

      @merchant_1.reload
      visit admin_merchants_path

      expect(page.all(:button, "Enable").count).to eq(5)
      expect(page.all(:button, "Disable").count).to eq(1)
    end
  end

  describe 'User Story 28' do
    before(:each) do
      test_data
    end

    it 'shows a list of enabled merchants' do
      @merchant_1.update(status: "enabled")
      @merchant_2.update(status: "enabled")
      visit admin_merchants_path
      within "#enabled_merchants" do
        expect(page).to have_content(@merchant_1.name)
        expect(page).to have_content(@merchant_2.name)
        expect(page).to_not have_content(@merchant_3.name)
        expect(page).to_not have_content(@merchant_4.name)
      end
    end

    it 'shows a list of disabled merchants' do
      @merchant_1.update(status: "enabled")
      @merchant_2.update(status: "enabled")
      visit admin_merchants_path
      within "#disabled_merchants" do
        expect(page).to have_content(@merchant_3.name)
        expect(page).to have_content(@merchant_4.name)
        expect(page).to_not have_content(@merchant_1.name)
        expect(page).to_not have_content(@merchant_2.name)
      end
    end
  end

  describe "user story 29" do
    before do
      test_data
    end

    it "has a link to create new merchants" do
      visit admin_merchants_path

      expect(page).to have_link("Add New Merchant", href: new_admin_merchant_path)
      click_link("Add New Merchant")
      expect(current_path).to eq(new_admin_merchant_path)
    end
  end
end