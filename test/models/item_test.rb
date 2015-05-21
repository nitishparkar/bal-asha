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


  test "needs" do
    # fixture dependency
    assert_equal Item.count, 2
    assert_equal Item.needs.values.first.count, 2
  end

end
