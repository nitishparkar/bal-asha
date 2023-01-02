require 'rails_helper'

RSpec.describe CallForAction, type: :model do
  it 'ensure that default status is pending for newly created records' do
    call_for_action = CallForAction.create!(date_of_action: DateTime.now, donor: create(:donor), person: create(:person))

    expect(call_for_action.pending?).to eq(true)
  end
end