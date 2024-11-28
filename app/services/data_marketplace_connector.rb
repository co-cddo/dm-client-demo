class DataMarketplaceConnector
  def self.create(record)
    new.create(record) # rubocop:disable Rails/SaveBang
  end

  def self.get(record)
    new.get(record)
  end

  def create(record)
    Faraday.post(
      "https://apitest.datamarketplace.gov.uk/v1/datasets",
      record.metadata.to_json,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{token}",
    )
  end

  def get(record)
    Faraday.get(
      File.join("https://apitest.datamarketplace.gov.uk/v1/datasets", record.remote_id),
      {},
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{token}",
    )
  end

  def token
    @token ||= begin
      response = Faraday.post(
        "https://apitest.datamarketplace.gov.uk/v1/clientauth/get-token",
        Rails.configuration.dm_api.to_json,
        "Content-Type" => "application/json",
      )
      json = JSON.parse(response.body)
      json["token"]
    end
  end
end
