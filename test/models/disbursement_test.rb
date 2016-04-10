require 'test_helper'

class DisbursementTest < ActiveSupport::TestCase

  test "disbursement_date is mandatory" do
    disbursement = disbursements(:disbursement1)
    disbursement.disbursement_date = nil
    assert_not disbursement.save
  end

  test "person_id is mandatory" do
    disbursement = disbursements(:disbursement1)
    disbursement.person_id = nil
    assert_not disbursement.save
  end

  test "disbursement should have transaction_items" do
    disbursement = disbursements(:disbursement1)
    disbursement.transaction_items.clear
    assert_not disbursement.save
  end

  test "disbursement that results in negative stock is not allowed" do
    item = Item.first
    item_quantity = item.stock_quantity

    disbursement = Disbursement.new(disbursement_date: Date.today, person_id: Person.first.id,
      transaction_items_attributes: { "0" => {quantity: item_quantity + 1, item_id: item.id}})
    assert_not disbursement.save

    disbursement = Disbursement.new(disbursement_date: Date.today, person_id: Person.first.id,
                                    transaction_items_attributes: { "0" => {quantity: item_quantity - 2, item_id: item.id}})
    assert disbursement.save

    assert_not disbursement.update(transaction_items_attributes: { "0" => {id: disbursement.transaction_items.first.id, quantity: item_quantity + 1, item_id: item.id}})
    assert disbursement.errors.full_messages.first.include?("Not enough")

    assert disbursement.update(transaction_items_attributes: { "0" => {id: disbursement.transaction_items.first.id, quantity: item_quantity, item_id: item.id}})
  end

  test "should delegate email to creator" do
    assert_not_empty disbursements(:disbursement1).creator_email
  end

  test "should accept nested attributes for transaction_items" do
    disbursement = Disbursement.new(disbursement_date: Date.today, person_id: Person.first.id,
      transaction_items_attributes: { "0" => {quantity: 1, item_id: Item.first.id}, "1" => {quantity: 1, item_id: Item.last.id}})
    assert disbursement.save
  end

  test "new disbursement should decrement stock" do
    milk = items(:milk)
    bread = items(:bread)

    initial_milk_stock = milk.stock_quantity
    initial_bread_stock = bread.stock_quantity

    disbursement = Disbursement.new(disbursement_date: Date.today, person_id: Person.first.id)
    disbursement.transaction_items.build(item_id: milk.id, quantity: 10)
    disbursement.transaction_items.build(item_id: bread.id, quantity: 10)
    disbursement.save

    assert_equal  initial_milk_stock - 10, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock - 10, items(:bread).reload.stock_quantity
  end

  test "deleting disbursement should increment stock" do
    milk = items(:milk)
    bread = items(:bread)

    initial_milk_stock = milk.stock_quantity
    initial_bread_stock = bread.stock_quantity

    disbursement = Disbursement.new(disbursement_date: Date.today, person_id: Person.first.id)
    disbursement.transaction_items.build(item_id: milk.id, quantity: 10)
    disbursement.transaction_items.build(item_id: bread.id, quantity: 10)
    disbursement.save

    assert_equal  initial_milk_stock - 10, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock - 10, items(:bread).reload.stock_quantity

    disbursement.destroy

    assert_equal  initial_milk_stock, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock, items(:bread).reload.stock_quantity
  end

  test "updating disbursement should update stock accordingly" do
    milk = items(:milk)
    bread = items(:bread)

    initial_milk_stock = milk.stock_quantity
    initial_bread_stock = bread.stock_quantity

    disbursement = Disbursement.new(disbursement_date: Date.today, person_id: Person.first.id)
    disbursement.transaction_items.build(item_id: milk.id, quantity: 10)
    disbursement.transaction_items.build(item_id: bread.id, quantity: 10)
    disbursement.save

    assert_equal  initial_milk_stock - 10, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock - 10, items(:bread).reload.stock_quantity

    milk_transaction_item = disbursement.transaction_items.detect{|ti| ti.item_id == milk.id }
    disbursement.update(transaction_items_attributes: { "0" => {id: milk_transaction_item.id, quantity: 5, item_id: milk.id}})

    assert_equal  initial_milk_stock - 5, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock - 10, items(:bread).reload.stock_quantity
  end

  test "it shouldn't matter if an item is repeated in a disbursement" do
    milk = items(:milk)

    initial_milk_stock = milk.stock_quantity

    disbursement = Disbursement.new(disbursement_date: Date.today, person_id: Person.first.id)
    disbursement.transaction_items.build(item_id: milk.id, quantity: 5)
    disbursement.transaction_items.build(item_id: milk.id, quantity: 10)
    disbursement.transaction_items.build(item_id: milk.id, quantity: 15)
    disbursement.save

    assert_equal  initial_milk_stock - 30, items(:milk).reload.stock_quantity

    disbursement.destroy

    assert_equal  initial_milk_stock, items(:milk).reload.stock_quantity
  end

end
