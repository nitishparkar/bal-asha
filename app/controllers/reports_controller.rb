class ReportsController < ApplicationController

  def daily_inventory
    category = Category.find_by_id(params[:category_id])

    begin
      inventory_date = Date.parse(params[:inventory_date])
    rescue ArgumentError, TypeError
      inventory_date = nil
    end

    if category && inventory_date
      service = DailyInventoryService.new(category, inventory_date)
      @daily_inventory = service.fetch_inventory
    else
      @daily_inventory = []
    end
  end

  def audit
    @search = Donation.non_kind.ransack(params[:q])
    @search.sorts = 'created_at ASC' if @search.sorts.empty?
    @search.date_daterange = "#{l(Date.today - 1.month, format: :formal)} - #{l(Date.today, format: :formal)}" unless params[:q]
    @donations = @search.result(distinct: true).includes(:donor)
  end

end
