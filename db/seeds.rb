meals_options_list = [
  { name: "Morning Breakfast", cost: 1000 },
  { name: "Evening Snacks", cost: 1000 },
  { name: "Infant Food", cost: 1000 },
  { name: "Medical", cost: 1000 },
  { name: "Milk", cost: 1500 },
  { name: "Lunch", cost: 2000 },
  { name: "Special Lunch", cost: 2500 },
  { name: "Dinner", cost: 2000 },
  { name: "Special Dinner", cost: 2500 },
  { name: "Birthday Celebration", cost: 4000 }
]

meals_options_list.each do |meal|
  MealOption.find_or_initialize_by(name: meal[:name]).tap do |obj|
    obj.cost = meal[:cost]
    obj.save!
  end
end