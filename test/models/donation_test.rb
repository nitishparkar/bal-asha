require 'test_helper'

class DonationTest < ActiveSupport::TestCase

  test "donor is mandatory" do
    donation = donations(:cash)
    donation.donor = nil
    assert_not donation.save
  end

  test "acceptor is mandatory" do
    donation = donations(:cash)
    donation.acceptor = nil
    assert_not donation.save
  end

  test "donation type is mandatory" do
    donation = donations(:cash)
    donation.type_cd = nil
    assert_not donation.save
  end

  test "donation date is mandatory" do
    donation = donations(:cash)
    donation.date = nil
    assert_not donation.save
  end

  test "payment_details are mandatory for cheque donations" do
    donation = donations(:cheque)
    donation.payment_details = nil
    assert_not donation.save
  end

  test "amount is mandatory for non-kind donations" do
    donation = donations(:cash)
    donation.amount = nil
    assert_not donation.save

    donation = donations(:cheque)
    donation.amount = nil
    assert_not donation.save

    donation = donations(:neft)
    donation.amount = nil
    assert_not donation.save
  end

  test "receipt_number is mandatory for cash and cheque donations" do
    donation = donations(:cash)
    donation.receipt_number = nil
    assert_not donation.save

    donation = donations(:cheque)
    donation.receipt_number = nil
    assert_not donation.save
  end

  test "amount should not be negative or zero" do
    donation = donations(:cash)
    donation.amount = -1
    assert_not donation.save

    donation = donations(:cash)
    donation.amount = 0
    assert_not donation.save
  end

  test "should delegate email to acceptor" do
    assert_not_empty donations(:cash).acceptor_email
  end

  test "should delegate full_name to donor" do
    assert_not_empty donations(:cash).donor_full_name
  end

  test "should delegate contact_info to donor" do
    assert_not_empty donations(:cash).donor_contact_info
  end

  test "should accept nested attributes for transaction_items" do
    donation = Donation.new(date: Date.today, person_id: Person.first.id,
                            donor_id: Donor.first.id, amount: 1000, receipt_number: "BAT76554", type_cd: 1,
                            transaction_items_attributes: { "0" => {quantity: 1, item_id: Item.first.id}, "1" => {quantity: 1, item_id: Item.last.id}})
    assert donation.save
  end

  test "amount should be calculated for kind donations" do
    milk = items(:milk)
    bread = items(:bread)

    donation = Donation.new(date: Date.today, person_id: Person.first.id,
                            donor_id: Donor.first.id, amount: 1000, receipt_number: "BAT76554", type_cd: 1)
    donation.transaction_items.build(item_id: milk.id, quantity: 10)
    donation.transaction_items.build(item_id: bread.id, quantity: 10)
    donation.save!

    assert_equal donation.amount, milk.current_rate * 10 + bread.current_rate * 10
  end

  test "amount should not be calculated for non-kind donations" do
    donation = donations(:cash)
    donation.save
    refute_equal donation.amount, 0
  end

  test "new kind donation should increment stock" do
    milk = items(:milk)
    bread = items(:bread)

    initial_milk_stock = milk.stock_quantity
    initial_bread_stock = bread.stock_quantity

    donation = Donation.new(date: Date.today, person_id: Person.first.id,
                            donor_id: Donor.first.id, amount: 1000, receipt_number: "BAT76554", type_cd: 1)
    donation.transaction_items.build(item_id: milk.id, quantity: 10)
    donation.transaction_items.build(item_id: bread.id, quantity: 10)
    donation.save!

    assert_equal  initial_milk_stock + 10, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock + 10, items(:bread).reload.stock_quantity
  end

  test "deleting kind donation should decrement stock" do
    milk = items(:milk)
    bread = items(:bread)

    initial_milk_stock = milk.stock_quantity
    initial_bread_stock = bread.stock_quantity

    donation = Donation.new(date: Date.today, person_id: Person.first.id,
                            donor_id: Donor.first.id, amount: 1000, receipt_number: "BAT76554", type_cd: 1)
    donation.transaction_items.build(item_id: milk.id, quantity: 10)
    donation.transaction_items.build(item_id: bread.id, quantity: 10)
    donation.save!

    assert_equal  initial_milk_stock + 10, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock + 10, items(:bread).reload.stock_quantity

    donation.destroy

    assert_equal  initial_milk_stock, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock, items(:bread).reload.stock_quantity
  end

  test "updating kind donation should update stock accordingly" do
    milk = items(:milk)
    bread = items(:bread)

    initial_milk_stock = milk.stock_quantity
    initial_bread_stock = bread.stock_quantity

    donation = Donation.new(date: Date.today, person_id: Person.first.id,
                            donor_id: Donor.first.id, amount: 1000, receipt_number: "BAT76554", type_cd: 1)
    donation.transaction_items.build(item_id: milk.id, quantity: 10)
    donation.transaction_items.build(item_id: bread.id, quantity: 10)
    donation.save!

    assert_equal  initial_milk_stock + 10, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock + 10, items(:bread).reload.stock_quantity

    milk_transaction_item = donation.transaction_items.detect { |ti| ti.item_id == milk.id }
    bread_transaction_item = donation.transaction_items.detect { |ti| ti.item_id == bread.id }
    donation.update(transaction_items_attributes: { "0" => {id: milk_transaction_item.id, quantity: 5, item_id: milk.id},
                                                    "1" => {id: bread_transaction_item.id, quantity: 15, item_id: bread.id}})

    assert_equal  initial_milk_stock + 5, items(:milk).reload.stock_quantity
    assert_equal  initial_bread_stock + 15, items(:bread).reload.stock_quantity
  end

  test "it shouldn't matter if an item is repeated in a donation" do
    milk = items(:milk)

    initial_milk_stock = milk.stock_quantity

    donation = Donation.new(date: Date.today, person_id: Person.first.id,
                            donor_id: Donor.first.id, amount: 1000, receipt_number: "BAT76554", type_cd: 1)
    donation.transaction_items.build(item_id: milk.id, quantity: 10)
    donation.transaction_items.build(item_id: milk.id, quantity: 10)
    donation.transaction_items.build(item_id: milk.id, quantity: 10)
    donation.save!

    assert_equal initial_milk_stock + 30, items(:milk).reload.stock_quantity

    donation.destroy

    assert_equal initial_milk_stock, items(:milk).reload.stock_quantity
  end

  test "receipt_number should get auto-generated for kind donations" do
    milk = items(:milk)

    donation = Donation.new(date: Date.today, person_id: Person.first.id,
                            donor_id: Donor.first.id, amount: 1000, receipt_number: "BAT76554", type_cd: 1)
    donation.transaction_items.build(item_id: milk.id, quantity: 10)
    donation.save!

    refute_empty donation.receipt_number
  end

  test '.amount_in_words returns word representation of the amount in title case' do
    assert_equal 'One Thousand One Rupees', Donation.new(amount: 1001).amount_in_words
  end

  test '.amount_in_words does not ignore the paise part when that is present' do
    assert_equal 'Nine Hundred Ninety Nine Rupees and Twenty Five Paise', Donation.new(amount: 999.25).amount_in_words
  end
end
