class MigrationClient
  def send_donor_details(donor_id, donor_details)
    response = http_client.post(path: '/donors/webhook/', body: [donor_details].to_json, expects: [200])
  rescue StandardError => e
    Rollbar.error(e, donor_id: donor_id)
    Rails.logger.error("[Migration] Failed to send donor details for #{donor_id} | #{e} | \n#{e.backtrace.join('\n')}")
  end

  private

  def http_client
    Excon.new(ENV['MIGRATION_BASE_URL'], headers: headers)
  end

  def headers
    {
      'Content-Type' => 'application/json',
      'X-Signature' =>  ENV['MIGRATION_SIGNATURE']
    }
  end
end
