require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  describe 'ensure that stock quantity remains positive after disbursement' do
    let(:category) { create(:category) }
    let(:rice) { create(:rice, category_id: category.id, stock_quantity: 10) }
    let(:wheat) { create(:wheat, category_id: category.id, stock_quantity: 20) }

    context 'when creation of a disbursement record would result in negative quantity for an item' do
      it 'fails the validation' do
        d = Disbursement.new(disbursement_date: Date.today, person_id: create(:person).id, transaction_items_attributes: [{ item_id: rice.id, quantity: 11 }, { item_id: wheat.id, quantity: 21 }])

        expect(d.validate).to eq(false)
        expect(d.errors.full_messages).to contain_exactly("Not enough #{rice.name}", "Not enough #{wheat.name}")
      end
    end

    context 'when updation of a disbursement record would result in negative quantity for an item' do
      it 'fails the validation' do
        d = Disbursement.create!(disbursement_date: Date.today, person_id: create(:person).id, transaction_items_attributes: [{ item_id: rice.id, quantity: 10 }, { item_id: wheat.id, quantity: 10 }])
        ti = d.transaction_items.first
        d.update(transaction_items_attributes: [{ id: ti.id, item_id: ti.item_id, quantity: ti.quantity + 1 }])

        expect(d.validate).to eq(false)
        expect(d.errors.full_messages).to eq(["Not enough #{ti.item.name}"])
      end
    end
  end
end
