module Transactionable
  extend ActiveSupport::Concern

  included do
    has_many :transaction_items, as: :transactionable, dependent: :destroy
    accepts_nested_attributes_for :transaction_items, allow_destroy: true, reject_if: proc { |attributes| attributes['item_id'].blank? }
  end

  private
    def add_to_stock
      self.transaction_items.with_deleted.each do |transaction_item|
        item = transaction_item.item.reload
        item.update_attribute(:stock_quantity,
                              item.stock_quantity + transaction_item.quantity)
      end
    end

    def remove_from_stock
      self.transaction_items.with_deleted.each do |transaction_item|
        item = transaction_item.item.reload
        item.update_attribute(:stock_quantity,
                              item.stock_quantity - transaction_item.quantity)
      end
    end

    def update_stock_positive
      self.transaction_items.each do |transaction_item|
        item = transaction_item.item.reload
        item.update_attribute(:stock_quantity,
                              item.stock_quantity - transaction_item.quantity_was + transaction_item.quantity)
      end
    end

    def update_stock_negative
      self.transaction_items.each do |transaction_item|
        item = transaction_item.item.reload
        item.update_attribute(:stock_quantity,
                              item.stock_quantity + transaction_item.quantity_was - transaction_item.quantity)
      end
    end
end
