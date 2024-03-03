# == Schema Information
#
# Table name: meal_options
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  cost       :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MealOption < ActiveRecord::Base
end
