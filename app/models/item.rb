# == Schema Information
#
# Table name: items
#
#  id               :integer          not null, primary key
#  name             :string(255)      default(""), not null
#  remarks          :text
#  deleted          :boolean          default(FALSE), not null
#  meta_data        :text
#  created_at       :datetime
#  updated_at       :datetime
#  current_rate     :decimal(8, 2)
#  unit             :string(255)
#  minimum_quantity :decimal(7, 2)
#  category_id      :integer
#

class Item < ActiveRecord::Base
  default_scope -> { where(deleted: false) }

  belongs_to :category

  store :meta_data, accessors: [], coder: Hash

  validates_presence_of :name, :current_rate, :minimum_quantity, :category
  validates_uniqueness_of :name, {scope: [:deleted, :remarks]}

  def identifier
    remarks.empty? ? name : name + " | " + remarks
  end
end
