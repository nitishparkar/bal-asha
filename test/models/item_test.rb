require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  test "name is mandatory" do
    item = items(:milk)
    item.name = nil
    assert_not item.save
  end

  test "current_rate is mandatory" do
    item = items(:milk)
    item.current_rate = nil
    assert_not item.save
  end

  test "minimum_quantity is mandatory" do
    item = items(:milk)
    item.minimum_quantity = nil
    assert_not item.save
  end

  test "category is mandatory" do
    item = items(:milk)
    item.category = nil
    assert_not item.save
  end

  test "stock_quantity is mandatory" do
    item = items(:milk)
    item.stock_quantity = nil
    assert_not item.save
  end

  test "name should be unique" do
    item1 = items(:milk)
    item2 = items(:bread)
    item1.name = item2.name
    assert_not item1.save
  end

  test "that needs returns all items where stock quantity is less than minimum quantity, grouped by category,
        sorted by urgency" do
    Item.delete_all
    Category.delete_all

    food = Category.create!(name: 'Grocery')
    food.items.create!(name: 'Rice', current_rate: 100, minimum_quantity: 100, stock_quantity: 99)
    food.items.create!(name: 'Wheat', current_rate: 100, minimum_quantity: 100, stock_quantity: 60)
    food.items.create!(name: 'Potato', current_rate: 100, minimum_quantity: 100, stock_quantity: 100)
    food.items.create!(name: 'Onion', current_rate: 100, minimum_quantity: 50, stock_quantity: 35)

    covid = Category.create!(name: 'Covid-19')
    covid.items.create!(name: 'Suit', current_rate: 100, minimum_quantity: 50, stock_quantity: 1)
    covid.items.create!(name: 'Gloves', current_rate: 100, minimum_quantity: 50, stock_quantity: 0)
    covid.items.create!(name: 'Shield', current_rate: 100, minimum_quantity: 100, stock_quantity: 2)
    covid.items.create!(name: 'Mask', current_rate: 100, minimum_quantity: 100, stock_quantity: 0)

    clothing = Category.create!(name: 'Clothing')
    clothing.items.create!(name: 'Pant', current_rate: 100, minimum_quantity: 0, stock_quantity: 100)

    needs = Item.needs

    sorted_needs = needs.sort_by { |k, _| k.name }
    assert_equal sorted_needs.map { |cat_items| cat_items[0].name }, ['Covid-19', 'Grocery']
    assert_equal sorted_needs.first[1].map(&:name), ['Mask', 'Gloves', 'Shield', 'Suit']
    assert_equal sorted_needs.last[1].map(&:name), ['Wheat', 'Onion', 'Rice']
  end
end
