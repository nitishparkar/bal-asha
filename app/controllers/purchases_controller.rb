class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  def index
    @search = Purchase.ransack(params[:q])
    @search.sorts = 'created_at DESC' if @search.sorts.empty?
    @purchases = @search.result(distinct: true).page(params[:page])
  end

  def show
  end

  def new
    @purchase = Purchase.new
  end

  def edit
  end

  def create
    @purchase = Purchase.new(purchase_params)

    if @purchase.save
      redirect_to purchases_url, notice: 'Purchase was successfully added.'
    else
      render :new
    end
  end

  def update
    if @purchase.update(purchase_params)
      redirect_to @purchase, notice: 'Purchase was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @purchase.destroy!

    redirect_to purchases_url, notice: 'Purchase was successfully removed.'
  end

  private
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    def purchase_params
      params.require(:purchase).permit(:purchase_date, :vendor, :remarks, :person_id, transaction_items_attributes: [:id, :quantity, :item_id, :_destroy])
    end
end
