class DisbursementsController < ApplicationController
  before_action :set_disbursement, only: [:show, :edit, :update, :destroy]

  def index
    @search = Disbursement.ransack(params[:q])
    @search.sorts = 'created_at DESC' if @search.sorts.empty?
    @disbursements = @search.result(distinct: true).includes(transaction_items: :item).page(params[:page])
  end

  def show
  end

  def new
    @disbursement = Disbursement.new
  end

  def edit
  end

  def create
    @disbursement = Disbursement.new(disbursement_params)

    if @disbursement.save
      redirect_to disbursement_path(@disbursement), notice: "Disbursement was successfully created."
    else
      render :new
    end
  end

  def update
    if @disbursement.update(disbursement_params)
      redirect_to disbursement_path(@disbursement), notice: "Disbursement was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @disbursement.destroy!
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
