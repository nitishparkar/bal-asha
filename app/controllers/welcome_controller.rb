class WelcomeController < ApplicationController

  def index
    @donors = Donor.upcoming_birthdays
  end

end
