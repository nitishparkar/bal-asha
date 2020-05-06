# == Schema Information
#
# Table name: items
#
#  id               :integer          not null, primary key
#  name             :string(255)      default(""), not null
#  remarks          :text
#  meta_data        :text
#  created_at       :datetime
#  updated_at       :datetime
#  current_rate     :decimal(8, 2)
#  unit             :string(255)
#  minimum_quantity :decimal(7, 2)
#  category_id      :integer
#  deleted_at       :datetime
#  stock_quantity   :decimal(10, 2)   default(0.0)
#

class Item < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :category

  store :meta_data, accessors: [], coder: Hash

  validates_presence_of :name, :current_rate, :minimum_quantity, :category, :stock_quantity
  validates_uniqueness_of :name

  delegate :name, to: :category, prefix: true, allow_nil: true

  def has_transaction_items?
    TransactionItem.where(item_id: id).exists?
  end

  def self.needs
    includes(:category)
      .select('items.*', 'items.stock_quantity/items.minimum_quantity*100 AS urgency')
      .where("stock_quantity < minimum_quantity")
      .order('urgency')
      .group_by(&:category)
  end

  def self.needs_csv(options = {})
    needs = self.needs

    CSV.generate(options) do |csv|
      csv << ["Name", "Wishlist", "Cost"]
      needs.each do |category, items|
        csv << []
        csv << [category.name]
        items.each do |item|
          wishlist_quantity = item.minimum_quantity - item.stock_quantity
          csv << [item.name, wishlist_quantity, wishlist_quantity * item.current_rate]
        end
      end
    end
  end
end
