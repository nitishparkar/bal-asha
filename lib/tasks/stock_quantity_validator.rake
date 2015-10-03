namespace :items do
  desc "Validate stock_quantity of all items"
  task :validate_stock_quantity => :environment do
    service = DailyInventoryService.new(nil, Date.tomorrow)

    Item.find_each do |item|
      balance = service.opening_balance(item.id)
      if balance != item.stock_quantity
        puts "#{item.name} should be #{balance}; stock_quantity #{item.stock_quantity}"
      end
    end
  end

  task :adjust_stock_quantity => :environment do
    service = DailyInventoryService.new(nil, Date.tomorrow)

    Item.find_each do |item|
      balance = service.opening_balance(item.id)
      if balance != item.stock_quantity
        puts "#{item.name} from #{item.stock_quantity} updated to #{balance}"
        item.update_attribute(:stock_quantity, balance)
      end
    end
  end
end
