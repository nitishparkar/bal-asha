class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  # GET /items
  # GET /items.json
  def index
    @search = Item.ransack(params[:q])
    @search.sorts = 'name asc' if @search.sorts.empty?
    @items = @search.result(distinct: true).includes(:category).page(params[:page])
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to items_url, notice: 'Item was successfully added.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to items_url, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    if @item.has_transaction_items?
      redirect_to items_url, alert: 'Could not delete the item. An entry exists with the item in it.'
    else
      @item.destroy
      redirect_to items_url, notice: 'Item was successfully removed.'
    end
  end

  # GET /items/needs.csv
  def needs
    send_data(Item.needs_csv, filename: "needs-#{Time.now.strftime("%d-%b-%H-%M")}.csv")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params[:item].permit(:name, :remarks, :current_rate, :unit, :minimum_quantity, :stock_quantity, :category_id)
    end
end
