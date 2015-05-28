require "test_helper"

class CallForActionTest < ActiveSupport::TestCase

  test "donor is mandatory" do
    call_for_action = call_for_actions(:pending)
    call_for_action.donor = nil
    assert_not call_for_action.save
  end

  test "person is mandatory" do
    call_for_action = call_for_actions(:pending)
    call_for_action.person = nil
    assert_not call_for_action.save
  end

  test "date_of_action is mandatory" do
    call_for_action = call_for_actions(:pending)
    call_for_action.date_of_action = nil
    assert_not call_for_action.save
  end

  test "status is mandatory" do
    call_for_action = call_for_actions(:pending)
    call_for_action.status = nil
    assert_not call_for_action.save
  end

  test "default status is pending" do
    call_for_action = CallForAction.new
    assert call_for_action.pending?
  end

  test "should delegate email to person" do
    assert_not_empty call_for_actions(:pending).person_email
  end

  test "should delegate full_name to donor" do
    assert_not_empty call_for_actions(:pending).donor_full_name
  end

  test "should delegate contact_info to donor" do
    assert_not_empty call_for_actions(:pending).donor_contact_info
  end

end
