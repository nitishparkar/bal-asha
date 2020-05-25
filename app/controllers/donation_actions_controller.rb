class DonationActionsController < ApplicationController
  def update
    donation = Donation.find(params[:donation_id])

    attrs_to_update = {}
    attrs_to_update[:receipt_mode_cd] = params[:receipt_mode_cd].to_i if params[:receipt_mode_cd].present?
    attrs_to_update[:thank_you_mode_cd] = params[:thank_you_mode_cd].to_i if params[:thank_you_mode_cd].present?

    if donation.donation_actions.update(attrs_to_update)
      flash[:notice] = "Updated successfully!"
      render json: {}, status: :ok
    else
      flash[:alert] = "Something went wrong!"
      render json: {}, status: :unprocessable_entity
    end
  end
end
