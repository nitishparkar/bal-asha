class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
    @items_category_ids = Item.pluck(:category_id).uniq
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Category was successfully created."
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    if Item.where(category_id: @category.id).exists?
      redirect_to categories_path, alert: "Cannot delete this Category. It has items."
    else
      @category.destroy
      redirect_to categories_path, notice: "Category was successfully destroyed."
    end
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
