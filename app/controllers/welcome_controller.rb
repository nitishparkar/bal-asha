class WelcomeController < ApplicationController

  def index
    @donors = Donor.upcoming_birthdays
    @needs = Item.needs
    @call_for_actions = CallForAction.pending
  end

end
