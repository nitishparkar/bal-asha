# == Schema Information
#
# Table name: programmes
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  label      :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Programme < ActiveRecord::Base
  has_and_belongs_to_many :donors
end
