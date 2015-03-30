# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

class Category < ActiveRecord::Base
  acts_as_paranoid

  validates :name, presence: true, uniqueness: true

  has_many :items
end
