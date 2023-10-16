class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @search = Item.ransack(params[:q])
    @search.sorts = 'name asc' if @search.sorts.empty?
    @items = @search.result(distinct: true).includes(:category).page(params[:page])
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to items_url, notice: 'Item was successfully added.'
    else
      render :new
    end
  end

  def update
    if @item.update(item_params)
      redirect_to items_url, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @item.has_transaction_items?
      redirect_to items_url, alert: 'Could not delete the item. An entry exists with the item in it.'
    else
      @item.destroy!

      redirect_to items_url, notice: 'Item was successfully removed.'
    end
  end

  def needs
    send_data(Item.needs_csv, filename: "needs-#{Time.now.strftime('%d-%b-%H-%M')}.csv")
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params[:item].permit(:name, :remarks, :current_rate, :unit, :minimum_quantity, :stock_quantity, :category_id)
    end
end
