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
        send_data(Donation.top_donors(@top_overall, @start_date, @end_date), filename: top_donors_filename)
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

  def form_10bd
    @form10bd_data = []

    if params[:daterange].present?
      start_date_string, end_date_string = params[:daterange].split(" - ")
      start_date = DateTime.parse(start_date_string).beginning_of_day
      end_date = DateTime.parse(end_date_string).end_of_day
      @form10bd_data = Form10bdGeneratorService.new(start_date, end_date).fetch_data
    end

    respond_to do |format|
      format.html do
        render "form_10bd"
      end
      format.csv do
        send_data(CSV.generate { |csv| @form10bd_data.map { |row| csv << row } }, filename: "form_10bd-#{params[:daterange]}.csv")
      end
    end
  end

  def foreign_donations
    @search = Donation.ransack(params[:q])
    @search.donor_donor_type_eq = Donor.donor_types['foreign']
    @search.date_daterange = "#{l(Date.today - 1.month, format: :formal)} - #{l(Date.today, format: :formal)}" unless params.dig(:q, :date_daterange)
    @search.sorts = 'date DESC'
    @donations = @search.result(distinct: true).includes(:donor)

    respond_to do |format|
      format.html { render "foreign_donations" }
      format.csv do
        send_data(Donation.foreign_donations_csv(@donations), filename: "foreign-donations-#{@search.date_daterange}.csv")
      end
    end
  end

  private

  def top_donors_filename
    daterange_label = params[:daterange].blank? ? 'alltime' : params[:daterange]
    "top-donors-#{params[:min_amount]}-#{daterange_label}.csv"
  end
end
