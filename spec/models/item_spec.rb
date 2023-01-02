require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    Item.delete_all
    Category.delete_all
  end

  describe '#has_transaction_items?' do
    let(:item) { create(:item) }
    context 'when there is a transaction_item associated with the item' do
      before do
        create(:transaction_item, :donation, item_id: item.id)
      end

      it 'returns true' do
        expect(item.has_transaction_items?).to eq(true)
      end
    end

    context 'when there is a transaction_item associated with the item' do
      it 'returns true' do
        expect(item.has_transaction_items?).to eq(false)
      end
    end
  end

  describe '.needs' do
    it 'returns all items where stock quantity is less than minimum quantity, grouped by category, sorted by urgency' do
      food = create(:category, name: 'Grocery')
      create(:item, category: food, name: 'Rice', current_rate: 100, minimum_quantity: 100, stock_quantity: 99)
      create(:item, category: food, name: 'Wheat', current_rate: 100, minimum_quantity: 100, stock_quantity: 60)
      create(:item, category: food, name: 'Potato', current_rate: 100, minimum_quantity: 100, stock_quantity: 100)
      create(:item, category: food, name: 'Onion', current_rate: 100, minimum_quantity: 50, stock_quantity: 35)

      covid = create(:category, name: 'Covid-19')
      create(:item, category: covid, name: 'Suit', current_rate: 100, minimum_quantity: 50, stock_quantity: 1)
      create(:item, category: covid, name: 'Gloves', current_rate: 100, minimum_quantity: 50, stock_quantity: 0)
      create(:item, category: covid, name: 'Shield', current_rate: 100, minimum_quantity: 100, stock_quantity: 2)
      create(:item, category: covid, name: 'Mask', current_rate: 100, minimum_quantity: 100, stock_quantity: 0)

      clothing = create(:category, name: 'Clothing')
      create(:item, category: clothing, name: 'Pant', current_rate: 100, minimum_quantity: 0, stock_quantity: 100)

      needs = Item.needs

      expect(needs.keys).to match_array(['Covid-19', 'Grocery'])
      expect(needs['Covid-19'].map(&:name)).to eq(['Mask', 'Gloves', 'Shield', 'Suit'])
      expect(needs['Grocery'].map(&:name)).to eq(['Wheat', 'Onion', 'Rice'])
    end

    context 'when no items are in need' do
      it 'returns an empty hash' do
        needs = Item.needs

        expect(needs).to eq({})
      end
    end
  end

  describe '.needs_csv' do
    it 'returns output of .needs in CSV format' do
      food = create(:category, name: 'Grocery')
      create(:item, category: food, name: 'Rice', current_rate: 100, minimum_quantity: 100, stock_quantity: 99)
      create(:item, category: food, name: 'Wheat', current_rate: 100, minimum_quantity: 100, stock_quantity: 60)

      covid = create(:category, name: 'Covid-19')
      create(:item, category: covid, name: 'Suit', current_rate: 100, minimum_quantity: 50, stock_quantity: 1)
      create(:item, category: covid, name: 'Gloves', current_rate: 100, minimum_quantity: 50, stock_quantity: 0)

      needs_csv = Item.needs_csv

      expect(needs_csv).to eq("Name,Wishlist,Cost

Covid-19
Gloves,50.0,5000.0
Suit,49.0,4900.0

Grocery
Wheat,40.0,4000.0
Rice,1.0,100.0
")
    end
  end
end