class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, except: :change_password

  # GET /people
  # GET /people.json
  def index
    @people = Person.all #.paginate(page: params[:page], per_page: 30)
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to people_path, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to people_path, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_path, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
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
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params[:person].permit(:email, :password, :type_cd)
    end

    def authenticate_admin!
      redirect_to root_path, alert: "Unauthorized" unless current_person.admin?
    end
end
