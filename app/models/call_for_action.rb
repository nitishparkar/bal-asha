# == Schema Information
#
# Table name: call_for_actions
#
#  id             :integer          not null, primary key
#  date_of_action :datetime
#  donor_id       :integer
#  status         :integer          default(0)
#  person_id      :integer
#  remarks        :text
#  deleted_at     :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

class CallForAction < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :donor
  belongs_to :person

  enum status: {pending: 0, done: 1}

  validates :date_of_action, :donor_id, :status, :person_id, presence: true

  delegate :full_name, to: :donor, prefix: true, allow_nil: true
  delegate :contact_info, to: :donor, prefix: true
  delegate :email, to: :person, prefix: true, allow_nil: true
end
