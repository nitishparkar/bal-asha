class CountriesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @countries = Country.all
  end

  def show
  end

  def new
    @country = Country.new
  end

  def edit
  end

  def create
    @country = Country.new(country_params)
    if @country.save
      redirect_to countries_path, notice: "Country was successfully created."
    else
      render :new
    end
  end

  def update
    if @country.update(country_params)
      redirect_to countries_path, notice: "Country was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @country.destroy
    redirect_to countries_path, notice: "Country was successfully destroyed."
  end

  private
    def set_country
      @country = Country.find(params[:id])
    end

    def country_params
      params.require(:country).permit(:name)
    end
end