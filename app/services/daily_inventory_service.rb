class DailyInventoryService
  attr_accessor :category, :inventory_date

  def initialize(category, inventory_date)
    @category = category
    @inventory_date = inventory_date

    # @category = Category.find_by_id(params[:category_id])
    # if @category.nil?
    #   @category = Category.first
    #   params[:category_id] = @category.id
    # end
    # begin
    #   @inventory_date = Date.parse(params[:inventory_date])
    # rescue ArgumentError, TypeError
    #   @inventory_date = Date.today
    # end
    # params[:inventory_date] = I18n.l(@inventory_date, format: :formal)
  end

  def fetch_inventory
    response = []
    Item.where(category_id: category.id).each do |item|
      opening_bal = opening_balance(item.id)
      dns = donations(item.id)
      pchs = purchases(item.id)
      dis = disbursements(item.id)
      closing_bal = closing_balance(opening_bal, dns, pchs, dis)
      response << InventoryItem.new(item, opening_bal, dns, pchs, dis, closing_bal)
    end
    response
  end


  def opening_balance(item_id)
    Donation.joins(:transaction_items).where(type_cd: Donation.type_cds[:kind],
      transaction_items: { item_id: item_id }).where("date < ?", inventory_date.beginning_of_day)
        .sum("transaction_items.quantity") +
    Purchase.joins(:transaction_items).where(transaction_items: { item_id: item_id })
      .where("purchase_date < ?", inventory_date.beginning_of_day)
        .sum("transaction_items.quantity") -
    Disbursement.joins(:transaction_items).where(transaction_items: { item_id: item_id })
      .where("disbursement_date < ?", inventory_date.beginning_of_day)
        .sum("transaction_items.quantity")
  end

  def donations(item_id)
    Donation.joins(:transaction_items).where(type_cd: Donation.type_cds[:kind],
      date: inventory_date.beginning_of_day..inventory_date.end_of_day,
        transaction_items: { item_id: item_id }).sum("transaction_items.quantity")
  end

  def purchases(item_id)
    Purchase.joins(:transaction_items).where(
      purchase_date: inventory_date.beginning_of_day..inventory_date.end_of_day,
        transaction_items: { item_id: item_id }).sum("transaction_items.quantity")
  end

  def disbursements(item_id)
    Disbursement.joins(:transaction_items).where(
      disbursement_date: inventory_date.beginning_of_day..inventory_date.end_of_day,
        transaction_items: { item_id: item_id }).sum("transaction_items.quantity")
  end

  def closing_balance(opening_balance, donations, purchases, disbursements)
    opening_balance + donations + purchases - disbursements
  end

end
