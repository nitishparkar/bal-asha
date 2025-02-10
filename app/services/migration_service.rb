class MigrationService
  WHITELISTED_PROGRAMMES = ['education_sponsorship']

  def sync_donor(donor)
    return unless donor_in_whitelisted_programs?(donor)

    donor_details = donor.attributes
    donor_details['_id'] = donor_details.delete('id')
    Donor.defined_enums.keys.each do |enum_column|
      donor_details[enum_column] = donor.read_attribute(enum_column)
    end
    donor_details['solicit'] = donor[:solicit] == true ? 1 : 0
    donor_details['date_of_birth'] = donor.date_of_birth&.iso8601
    donor_details['created_at'] = donor.created_at.iso8601
    donor_details['updated_at'] = donor.updated_at.iso8601
    donor_details['deleted_at'] = donor.deleted_at&.iso8601

    Rails.logger.info("[Migration] Syncing Donor #{donor_details}")

    MigrationClient.new.send_donor_details(donor.id, donor_details)
  end

  private

  def donor_in_whitelisted_programs?(donor)
    donor.programmes.exists?(name: WHITELISTED_PROGRAMMES)
  end
end
