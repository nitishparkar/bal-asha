FactoryBot.define do
  factory :item do
    name { "#{Faker::Lorem.word}#{Faker::Number.number(3)}" }
    remarks { Faker::Lorem.sentence }
    current_rate { Faker::Number.number(3) }
    unit             { 'kg' }
    minimum_quantity { 10 }
    category_id      { create(:category).id }
    stock_quantity   { 100 }
  end

  factory :rice, class: Item do
    name { 'Rice' }
    remarks { 'kolam' }
    current_rate { 43.5 }
    unit             { 'kg' }
    minimum_quantity { 20 }
    category_id      { create(:category).id }
    stock_quantity   { 0 }
  end

  factory :wheat, class: Item do
    name { 'Wheat' }
    remarks { 'bigbasket' }
    current_rate { 63 }
    unit             { 'kg' }
    minimum_quantity { 10 }
    category_id      { create(:category).id }
    stock_quantity   { 0 }
  end
end
