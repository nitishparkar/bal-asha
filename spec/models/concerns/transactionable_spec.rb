require 'rails_helper'

RSpec.shared_examples 'a stock decreaser' do |subject, subject_params|
  let(:category) { create(:category) }
  let(:rice) { create(:rice, category_id: category.id, stock_quantity: 10) }
  let(:wheat) { create(:wheat, category_id: category.id, stock_quantity: 20) }

  context 'when created' do
    it 'removes items from stock' do
      subject.create!(subject_params.merge(transaction_items_attributes: [{ item_id: rice.id, quantity: rice.stock_quantity }, { item_id: wheat.id, quantity: wheat.stock_quantity }]))

      expect(rice.reload.stock_quantity.to_i).to eq(0)
      expect(wheat.reload.stock_quantity.to_i).to eq(0)
    end
  end

  context 'when deleted' do
    it 'adds items to stock' do
      transactionable = subject.create!(subject_params.merge(transaction_items_attributes: [{ item_id: rice.id, quantity: rice.stock_quantity }, { item_id: wheat.id, quantity: wheat.stock_quantity }]))

      transactionable.destroy!

      expect(rice.reload.stock_quantity.to_i).to eq(10)
      expect(wheat.reload.stock_quantity.to_i).to eq(20)
    end
  end
end

RSpec.shared_examples 'a stock increaser' do |subject, subject_params|
  let(:category) { create(:category) }
  let(:rice) { create(:rice, category_id: category.id, stock_quantity: 0) }
  let(:wheat) { create(:wheat, category_id: category.id, stock_quantity: 0) }

  context 'when created' do
    it 'adds items to stock' do
      subject.create!(subject_params.merge(transaction_items_attributes: [{ item_id: rice.id, quantity: 10 }, { item_id: wheat.id, quantity: 20 }]))

      expect(rice.reload.stock_quantity.to_i).to eq(10)
      expect(wheat.reload.stock_quantity.to_i).to eq(20)
    end
  end

  context 'when deleted' do
    it 'removes items from stock' do
      transactionable = subject.create!(subject_params.merge(transaction_items_attributes: [{ item_id: rice.id, quantity: 10 }, { item_id: wheat.id, quantity: 20 }]))

      transactionable.destroy!

      expect(rice.reload.stock_quantity.to_i).to eq(0)
      expect(wheat.reload.stock_quantity.to_i).to eq(0)
    end
  end
end
