programmes = [
  { name: 'general_fund', label: 'General Fund' },
  { name: 'food_sponsorships', label: 'Food Sponsorships' },
  { name: 'education_sponsorship', label: 'Education Sponsorship' },
  { name: 'nutrition_programme', label: 'Nutrition Programme' },
  { name: 'child_development_centre', label: 'Child Development Centre' },
  { name: 'corpus_fund', label: 'Corpus Fund' },
  { name: 'medical_fund', label: 'Medical Fund' },
  { name: 'education_fund', label: 'Education Fund' },
  { name: 'nutrition_fund', label: 'Nutrition Fund' },
  { name: 'building_repairs_fund', label: 'Building & Repairs Fund' },
  { name: 'clothes_shoes_bedding', label: 'Clothes, Shoes & Bedding' },
  { name: 'mumkin', label: 'Mumkin' },
  { name: 'adoption_programme', label: 'Adoption Programme '}
]

programmes.each do |programme_data|
  Programme.find_or_initialize_by(name: programme_data[:name]).tap do |programme|
    programme.label = programme_data[:label]
    programme.save!
  end
end
