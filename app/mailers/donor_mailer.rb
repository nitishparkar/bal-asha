class DonorMailer < ApplicationMailer
  def send_donation_receipt(to)
    mail(to: to, subject: 'Thanks for signing up for our amazing app')
  end
end