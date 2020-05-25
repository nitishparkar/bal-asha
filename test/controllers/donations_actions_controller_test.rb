class DonationActionsControllerTest < ActionController::TestCase

  def setup
    sign_in people(:nitish)
  end

  test "should update receipt_mode_cd and thank_you_mode_cd" do
    donation = Donation.create!(date: Date.today, person_id: Person.first.id,
                                donor_id: Donor.first.id, amount: 1000, receipt_number: "BAT76554", type_cd: 0)

    patch :update, donation_id: donation.id, receipt_mode_cd: "2", thank_you_mode_cd: "3"

    assert_response :success
    actions = donation.reload.donation_actions
    assert_equal 2, actions.read_attribute(:receipt_mode_cd)
    assert_equal 3, actions.read_attribute(:thank_you_mode_cd)
  end

end
