class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  alias current_user current_person # For CanCanCan

  before_action :authenticate_person!

  def user_for_paper_trail
    current_person.nil? ? "" : current_person.id
  end
end
