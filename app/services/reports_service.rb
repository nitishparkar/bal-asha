class ReportsService

  def self.total_kind_donations(start_date, end_date, category_id)
    if start_date && end_date && category_id
      category = Category.find(category_id)
      TransactionItem.joins(:donation).includes(:item)
          .where(donations: { date: start_date.beginning_of_day..end_date.end_of_day }, item_id: category.item_ids)
          .group_by(&:item_id)
    else
      {}
    end
  end

end
