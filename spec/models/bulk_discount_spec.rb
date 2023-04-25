require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant}
    it { should have_many(:items).through(:merchant)}
    it { should have_many(:invoices).through(:items)}
  end

  describe 'validations' do
    it { should validate_presence_of :name}
    it { should validate_presence_of :percentage_discounts}
    it { should validate_presence_of :quantity_threshold}
  end

  describe "instance methods" do
    it "percentage" do
      merchant = FactoryBot.create(:merchant)
      bulk_discount = FactoryBot.create(:bulk_discount, merchant: merchant, percentage_discounts: 0.75, name: "75% off 10 items", quantity_threshold: 10)

      expect(bulk_discount.percentage).to eq(75)
    end
  end
end
