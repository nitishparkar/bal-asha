namespace :donors do
  desc "Backfill identification_type and identification_no from pan_card_no"
  task backfill_identification_fields: :environment do
    count = 0
    Donor.where.not(pan_card_no: [nil, ""]).find_each do |donor|
      donor.update!(identification_type: Donor.identification_types['pan_card'], identification_no: donor.pan_card_no)
      puts "Updated #{donor.id}"
      count += 1
    end
    puts "Total #{count} donors updated"
  end
end
