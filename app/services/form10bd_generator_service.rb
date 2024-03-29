class Form10bdGeneratorService
  SECTION_CODE = 'Section 80G'.freeze
  URN = ENV['BAL_ASHA_URN']
  URN_DATE = '05-28-2021'.freeze
  CASH_DONATION_THRESHOLD = 2000
  HEADERS = ["SI. No.", "Pre Acknowledgement Number", "ID Code", "Unique Identification Number", "Section Code", "Unique Registration Number (URN)", "Date of Issuance of Unique Registration Number", "Name of donor", "Address of donor", "Donation Type", "Mode of receipt", "Amount of donation (Indian rupees)"].freeze
  DONATION_TYPE_CASH = Donation.type_cds['cash']
  DONATION_TYPES_ELECTRONIC = [Donation.type_cds['cheque'], Donation.type_cds['neft'], Donation.type_cds['online']].freeze
  COLUMNS_TO_PLUCK = 'donor_id, donors.identification_type, donors.identification_no, receipt_number, donors.first_name, donors.last_name, donors.address, category, type_cd, SUM(amount)'.freeze

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  # TODO: Simplifty this. Earlier cash and electronic donations had separate rules, hence separate functions.
  def fetch_data
    data = (electronic_donations_data + cash_donations_data).map do |row|
      [row[0], '', identification_name(row[1]), row[2], SECTION_CODE, URN, URN_DATE,
       "#{row[4]} #{row[5]}".strip, row[6], donation_type(row[7]), mode_of_receipt(row[8]), row[9]]
    end

    data.empty? ? data : data.unshift(HEADERS)
  end

  private

  attr_reader :start_date, :end_date

  def electronic_donations_data
    Donation.joins(:donor)
            .where(type_cd: DONATION_TYPES_ELECTRONIC)
            .where.not(donors: { donor_type: Donor.donor_types['foreign'] })
            .between_dates(start_date, end_date)
            .order(:created_at)
            .group(:donor_id, :category)
            .pluck(COLUMNS_TO_PLUCK)
  end

  def cash_donations_data
    Donation.joins(:donor)
            .where(type_cd: DONATION_TYPE_CASH)
            .where.not(donors: { donor_type: Donor.donor_types['foreign'] })
            .between_dates(start_date, end_date)
            .order(:created_at)
            .group(:donor_id, :category)
            .pluck(COLUMNS_TO_PLUCK)
  end

  # rubocop:disable Metrics/CyclomaticComplexity?
  # This could be turned into a hash lookup to avoid the warning, but that won't make it any more readable.
  def identification_name(identification_type)
    case identification_type
    when Donor.identification_types['pan_card']
      'Permanent Account Number'
    when Donor.identification_types['aadhaar_card']
      'Aadhaar Number'
    when Donor.identification_types['passport']
      'Passport number'
    when Donor.identification_types['voter_id_card']
      'Elector\'s photo identity number'
    when Donor.identification_types['driving_license']
      'Driving License number'
    when Donor.identification_types['ration_card']
      'Ration card number'
    when Donor.identification_types['tax_payer_country_of_residence']
      'Tax Identification Number'
    else
      ''
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity?

  def donation_type(category)
    case category
    when Donation.categories['others']
      'Others'
    when Donation.categories['corpus']
      'Corpus'
    when Donation.categories['specific_grants']
      'Specific grant'
    else
      ''
    end
  end

  def mode_of_receipt(type_cd)
    case type_cd
    when DONATION_TYPE_CASH
      'Cash'
    when *DONATION_TYPES_ELECTRONIC
      'Electronic modes including account payee cheque/draft'
    else
      ''
    end
  end
end
