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
    @search.sorts = 'receipt_number ASC' if @search.sorts.empty?
    @search.date_daterange = "#{l(Date.today - 1.month, format: :formal)} - #{l(Date.today, format: :formal)}" unless params[:q]
    @donations = @search.result(distinct: true).includes(:donor)
    respond_to do |format|
      format.html { render "audit" }
      format.csv do
        send_data(Donation.audit_csv(@donations), filename: "audit-#{@search.date_daterange}.csv")
      end
    end
  end

  def top_donors
    params[:min_amount] = params[:min_amount] ? params[:min_amount].to_i : 30000
    @top_kind = Donation.top_kind_above(params[:min_amount])
    @top_non_kind = Donation.top_non_kind_above(params[:min_amount])
    @top_overall = Donation.top_overall_above(params[:min_amount])

    # TODO: Make this more robust
    if params[:daterange].present?
      start_date_string, end_date_string = params[:daterange].split(" - ")
      @start_date = DateTime.parse(start_date_string)
      @end_date = DateTime.parse(end_date_string).end_of_day

      @daterange_field_text = "#{l(@start_date, format: :formal)} - #{l(@end_date, format: :formal)}"

      @top_kind = @top_kind.between_dates(@start_date, @end_date)
      @top_non_kind = @top_non_kind.between_dates(@start_date, @end_date)
      @top_overall = @top_overall.between_dates(@start_date, @end_date)
    end

    respond_to do |format|
      format.html { render "top_donors" }
      format.csv do
        send_data(Donation.top_donors(@top_overall), filename: top_donors_filename)
      end
    end
  end

  def total_kind_donations
    begin
      if params[:date_range].present? && params[:date_range].include?(' - ')
        dt = params[:date_range].split(' - ')
        start_date = Date.parse(dt[0])
        end_date = Date.parse(dt[1])
      end
    rescue ArgumentError
      start_date = end_date = nil
    end

    @total_kind_donations = ReportsService.total_kind_donations(start_date, end_date, params[:category_id])
  end

  def donation_acknowledgements
    if params[:daterange].present?
      start_date_string, end_date_string = params[:daterange].split(" - ")
      @start_date = DateTime.parse(start_date_string)
      @end_date = DateTime.parse(end_date_string).end_of_day
    else
      @start_date = (Date.today - 1.month).beginning_of_month.to_datetime
      @end_date = Date.today.end_of_month.to_datetime.end_of_day
    end

    @daterange_field_text = "#{l(@start_date, format: :formal)} - #{l(@end_date, format: :formal)}"
    @donations = Donation.joins(:donation_actions).eager_load(:donor, :donation_actions)
                         .where(date: @start_date..@end_date).order(date: :asc)

    respond_to do |format|
      format.html { render "donation_acknowledgements" }
      format.csv do
        send_data(Donation.donation_acknowledgements_csv(@donations), filename: "donation-ack-#{@daterange_field_text}.csv")
      end
    end
  end

  private

  def top_donors_filename
    daterange_label = params[:daterange].blank? ? 'alltime' : params[:daterange]
    "top-donors-#{params[:min_amount]}-#{daterange_label}.csv"
  end
end
