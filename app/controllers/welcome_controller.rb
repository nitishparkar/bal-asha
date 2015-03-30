class WelcomeController < ApplicationController

  def index
    @donors = Donor.upcoming_birthdays
    @needs = Item.needs
  end

end
