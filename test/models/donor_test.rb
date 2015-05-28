require 'test_helper'

class DonorTest < ActiveSupport::TestCase

  test "first_name is mandatory" do
    donor = donors(:john)
    donor.first_name = nil
    assert_not donor.save
  end

  test "country_code is mandatory" do
    donor = donors(:john)
    donor.country_code = nil
    assert_not donor.save
  end

  test "trust_no is mandatory if donor_type is trust" do
    donor = donors(:balasha)
    donor.trust_no = nil
    assert_not donor.save
  end

  test "at least one contact is present" do
    donor = donors(:john)

    donor.mobile = "9005658589"
    assert donor.save

    donor.mobile = nil
    assert_not donor.save

    donor.email = "john@genii.in"
    assert donor.save

    donor.email = nil
    assert_not donor.save

    donor.telephone = "25458785"
    assert donor.save

    donor.telephone = nil
    assert_not donor.save
  end

  test "default level is general" do
    donor = Donor.new
    assert donor.general?
  end

  test "full_name" do
    donor = Donor.new(first_name: "John", last_name: "Doe")
    assert_equal donor.full_name, "John Doe"

    donor.last_name = nil
    assert_equal donor.full_name, "John"
  end

  # fixture dependency
  test "upcoming birthdays" do
    # Total 2 donors in db
    assert_equal Donor.count, 2

    # Out of the 2, 1 has upcoming birthday
    assert_equal Donor.upcoming_birthdays.count, 1
  end

  test "should respond to contact_info" do
    assert_not_empty donors(:john).contact_info
  end

  test "should respond to full_address" do
    assert_not_empty donors(:john).full_address
  end

end
