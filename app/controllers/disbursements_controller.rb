class DisbursementsController < ApplicationController
  before_action :set_disbursement, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @search = Disbursement.ransack(params[:q])
    @search.sorts = 'created_at DESC' if @search.sorts.empty?
    @disbursements = @search.result(distinct: true).page(params[:page])
  end

  def show
    respond_with(@disbursement)
  end

  def new
    @disbursement = Disbursement.new
    respond_with(@disbursement)
  end

  def edit
  end

  def create
    @disbursement = Disbursement.new(disbursement_params)
    @disbursement.save
    respond_with(@disbursement)
  end

  def update
    @disbursement.update(disbursement_params)
    respond_with(@disbursement)
  end

  def destroy
    @disbursement.destroy
    redirect_to disbursements_url
  end

  private
    def set_disbursement
      @disbursement = Disbursement.find(params[:id])
    end

    def disbursement_params
      params[:disbursement].permit(:disbursement_date, :remarks, :person_id, transaction_items_attributes: [:id, :quantity, :item_id, :_destroy])
    end
end
