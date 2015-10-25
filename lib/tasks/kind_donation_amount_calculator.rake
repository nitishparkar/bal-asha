namespace :donations do
  desc "Calculate and update donation amount"
  task :set_amount => :environment do
    Donation.unscoped.kind.find_each do |donation|
      total_amount = donation.transaction_items.map{ |ti| ti.rate * ti.quantity }.sum
      donation.update_attribute(:amount, total_amount)
    end
  end
end
