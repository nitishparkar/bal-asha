require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  test "name is mandatory" do
    category = Category.new
    assert_not category.save
  end

  test "name should be unique" do
    Category.create(name: "Food")
    category = Category.new(name: "Food")
    assert_not category.save
  end

end
