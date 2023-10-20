class PeopleController < ApplicationController
  before_action :set_person, only: [:edit, :update, :destroy]

  authorize_resource
  skip_authorize_resource only: [:change_password]

  def index
    @people = Person.where.not(id: current_person.id)
  end

  def new
    @person = Person.new
  end

  def edit
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to people_path, notice: 'Person was successfully created.'
    else
      render :new
    end
  end

  def update
    params[:person].delete(:password) if params[:person].present? && params[:person][:password].blank?

    if @person.update(person_params)
      redirect_to people_path, notice: 'Person was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @person.destroy!

    redirect_to people_path, notice: 'Person was successfully removed.'
  end

  def change_password
    @person = current_person

    if request.post?
      if @person.update_attributes(params[:person].permit(:password, :password_confirmation))
        sign_in @person, bypass: true
        redirect_to root_path, notice: "Password Changed"
      else
        render "change_password"
      end
    end
  end

  private
    def set_person
      @person = Person.where.not(id: current_person.id).find(params[:id])
    end

    def person_params
      params[:person].permit(current_ability.permitted_attributes(params[:action].to_sym, Person))
    end
end
