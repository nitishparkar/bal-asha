# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  remarks    :text
#  deleted    :boolean          default(FALSE), not null
#  meta_data  :text
#  created_at :datetime
#  updated_at :datetime
#

class Item < ActiveRecord::Base
  default_scope -> { where(deleted: false) }

  store :meta_data, accessors: [], coder: Hash

  validates_presence_of :name
  validates_uniqueness_of :name, {scope: [:deleted, :remarks]}

  def identifier
    name + " | " + remarks
  end
end
