# == Schema Information
#
# Table name: donation_actions
#
#  id                :integer          not null, primary key
#  donation_id       :integer          not null
#  receipt_mode_cd   :integer          default(0), not null
#  thank_you_mode_cd :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class DonationActions < ActiveRecord::Base

  belongs_to :donation

  enum receipt_mode_cd: { not_sent: 0, no: 1, yes: 2 }
  enum thank_you_mode_cd: { pending: 0, na: 1, call: 2, whatsapp: 3, email: 4 }

  validates_presence_of :donation_id, :receipt_mode_cd, :thank_you_mode_cd

  def receipt_mode
    receipt_mode_cd == "not_sent" ? "" : receipt_mode_cd.upcase
  end

  def thank_you_mode
    thank_you_mode_cd == "pending" ? "" : thank_you_mode_cd.upcase
  end
end
