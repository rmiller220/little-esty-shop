FactoryBot.define do
  factory :bulk_discount do
    percentage_discounts { 1.5 }
    quantity_threshold { 1 }
    merchant { nil }
  end
end
