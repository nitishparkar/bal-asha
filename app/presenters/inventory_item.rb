class InventoryItem
  attr_reader :item, :opening_balance, :donations, :purchases, :disbursements, :closing_balance

  def initialize(item, opening_balance, donations, purchases, disbursements, closing_balance)
    @item = item
    @opening_balance = opening_balance
    @donations = donations
    @purchases = purchases
    @disbursements = disbursements
    @closing_balance = closing_balance
  end

end
