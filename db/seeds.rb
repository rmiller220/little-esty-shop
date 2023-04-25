# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

InvoiceItem.destroy_all
Transaction.destroy_all
Invoice.destroy_all
Item.destroy_all
Customer.destroy_all
Merchant.destroy_all
# @merchant_1 = Merchant.create!(name: "Schroeder-Jerde")
# @merchant_2 = Merchant.create!(name: "James Bond")
# @bulk_discount1 = @merchant_1.bulk_discounts.create!(name: "10% Discount off 10 items", percentage_discounts: 0.10, quantity_threshold: 10, merchant_id: 1)
# @bulk_discount2 = @merchant_1.bulk_discounts.create!(name: "20% Discount off 15 items", percentage_discounts: 0.20, quantity_threshold: 15, merchant_id: 1)
# @bulk_discount3 = @merchant_2.bulk_discounts.create!(name: "30% Discount off 20 items", percentage_discounts: 0.30, quantity_threshold: 20, merchant_id: 2)
# @bulk_discount4 = @merchant_2.bulk_discounts.create!(name: "15% Discount off 10 items", percentage_discounts: 0.15, quantity_threshold: 10, merchant_id: 2)
system("rails fake_import")