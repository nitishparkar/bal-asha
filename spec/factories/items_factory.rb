FactoryBot.define do
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
