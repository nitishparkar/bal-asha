require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase

  test "purchase_date is mandatory" do
    purchase = purchases(:purchase1)
    purchase.purchase_date = nil
    assert_not purchase.save
  end

  test "vendor is mandatory" do
    purchase = purchases(:purchase1)
    purchase.vendor = nil
    assert_not purchase.save
  end

  test "person_id is mandatory" do
    purchase = purchases(:purchase1)
    purchase.person_id = nil
    assert_not purchase.save
  end

  test "purchase should have transaction_items" do
    purchase = purchases(:purchase1)
    purchase.transaction_items.clear
    assert_not purchase.save
  end

  test "should delegate email to creator" do
    assert_not_empty purchases(:purchase1).creator_email
  end

  test "should accept nested attributes for transaction_items" do
    purchase = Purchase.new(purchase_date: Date.today, person_id: Person.first.id, vendor: "Genii",
                            transaction_items_attributes: { "0" => {quantity: 1, item_id: Item.first.id}, "1" => {quantity: 1, item_id: Item.last.id}})
    assert purchase.save
  end

  test "new purchase should increment stock" do
    milk = items(:milk)
    bread = items(:bread)

    initial_milk_stock = milk.stock_quantity
    initial_bread_stock = bread.stock_quantity

    purchase = Purchase.new(purchase_date: Date.today, person_id: Person.first.id, vendor: "Genii")
    purchase.transaction_items.build(item_id: milk.id, quantity: 10)
    purchase.transaction_items.build(item_id: bread.id, quantity: 10)
    purchase.save

    assert_equal  initial_milk_stock + 10, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock + 10, items(:bread).reload.stock_quantity
  end

  test "deleting purchase should decrement stock" do
    milk = items(:milk)
    bread = items(:bread)

    initial_milk_stock = milk.stock_quantity
    initial_bread_stock = bread.stock_quantity

    purchase = Purchase.new(purchase_date: Date.today, person_id: Person.first.id, vendor: "Genii")
    purchase.transaction_items.build(item_id: milk.id, quantity: 10)
    purchase.transaction_items.build(item_id: bread.id, quantity: 10)
    purchase.save

    assert_equal  initial_milk_stock + 10, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock + 10, items(:bread).reload.stock_quantity

    purchase.destroy

    assert_equal  initial_milk_stock, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock, items(:bread).reload.stock_quantity
  end

  test "updating purchase should update stock accordingly" do
    milk = items(:milk)
    bread = items(:bread)

    initial_milk_stock = milk.stock_quantity
    initial_bread_stock = bread.stock_quantity

    purchase = Purchase.new(purchase_date: Date.today, person_id: Person.first.id, vendor: "Genii")
    purchase.transaction_items.build(item_id: milk.id, quantity: 10)
    purchase.transaction_items.build(item_id: bread.id, quantity: 10)
    purchase.save

    assert_equal  initial_milk_stock + 10, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock + 10, items(:bread).reload.stock_quantity

    milk_transaction_item = purchase.transaction_items.detect { |ti| ti.item_id == milk.id }
    purchase.update(transaction_items_attributes: { "0" => {id: milk_transaction_item.id, quantity: 5, item_id: milk.id}})

    assert_equal  initial_milk_stock + 5, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock + 10, items(:bread).reload.stock_quantity
  end

  test "it shouldn't matter if an item is repeated in a purchase" do
    milk = items(:milk)

    initial_milk_stock = milk.stock_quantity

    purchase = Purchase.new(purchase_date: Date.today, person_id: Person.first.id, vendor: "Genii")
    purchase.transaction_items.build(item_id: milk.id, quantity: 10)
    purchase.transaction_items.build(item_id: milk.id, quantity: 5)
    purchase.transaction_items.build(item_id: milk.id, quantity: 5)
    purchase.save

    assert_equal initial_milk_stock + 20, items(:milk).reload.stock_quantity

    purchase.destroy

    assert_equal initial_milk_stock, items(:milk).reload.stock_quantity
  end

end
