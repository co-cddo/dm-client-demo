class DataMarketplaceConnector
  def self.create(record)
    new.create(record) # rubocop:disable Rails/SaveBang
  end

  def create(record)
    Faraday.post(
      "https://apitest.datamarketplace.gov.uk/v1/datasets",
      record.metadata.to_json,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{token}",
    )
  end

  def token
    @token ||= begin
      response = Faraday.post(
        "https://apitest.datamarketplace.gov.uk/v1/clientauth/get-token",
        Rails.application.credentials.dm_api.to_json,
        "Content-Type" => "application/json",
      )
      json = JSON.parse(response.body)
      json["token"]
    end
  end
end
