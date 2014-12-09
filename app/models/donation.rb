# == Schema Information
#
# Table name: donations
#
#  id         :integer          not null, primary key
#  date       :datetime
#  donor_id   :integer
#  type_cd    :integer
#  amount     :decimal(10, 2)
#  quantity   :decimal(6, 2)
#  remarks    :text
#  deleted    :boolean          default(FALSE), not null
#  meta_data  :text
#  person_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Donation < ActiveRecord::Base
  default_scope -> { where(deleted: false) }

  store :meta_data, accessors: [], coder: Hash

  belongs_to :donor
  belongs_to :acceptor, class_name: Person, foreign_key: 'person_id'

  enum type_cd: {cash: 0, kind: 1}

  validates_presence_of :donor, :acceptor, :type_cd, :date

  delegate :full_name, to: :donor, prefix: true
  delegate :contact_info, to: :donor, prefix: true
end
