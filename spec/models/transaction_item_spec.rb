require 'rails_helper'

RSpec.describe TransactionItem, type: :model do
  describe '#set_rate' do
    it 'sets the rate to the current rate of the item' do
      item = create(:item)
      transaction_item = build(:transaction_item, item: item)

      transaction_item.validate

      expect(transaction_item.rate).to eq(item.current_rate)
    end
  end
end
