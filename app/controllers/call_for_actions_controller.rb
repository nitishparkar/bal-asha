class CallForActionsController < ApplicationController
  before_action :set_donor
  before_action :set_call_for_action, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @call_for_action = @donor.call_for_actions.build
  end

  def edit
  end

  def create
    @call_for_action = @donor.call_for_actions.new(call_for_action_params)

    if @call_for_action.save
      redirect_to donor_path(@donor), notice: 'Call for action was successfully added.'
    else
      render :new
    end
  end

  def update
    if @call_for_action.update(call_for_action_params)
      redirect_to donor_path(@donor), notice: 'Call for action was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @call_for_action.destroy
    redirect_to donor_path(@donor), notice: 'Call for action was successfully removed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donor
      @donor = Donor.find(params[:donor_id])
    end

    def set_call_for_action
      @call_for_action = @donor.call_for_actions.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def call_for_action_params
      params.require(:call_for_action).permit(:date_of_action, :status, :remarks, :person_id)
    end
end
