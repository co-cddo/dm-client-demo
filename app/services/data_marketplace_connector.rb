class DataMarketplaceConnector
  def self.create(record)
    new(record).create # rubocop:disable Rails/SaveBang
  end

  def self.get(record)
    new(record).get
  end

  def self.update(record)
    new(record).update # rubocop:disable Rails/SaveBang
  end

  def self.remove(record)
    new(record).remove
  end

  def self.dataset_url(record)
    new(record).dataset_url
  end

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def create
    Faraday.post(
      datasets_root_url,
      record.metadata.to_json,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{token}",
    )
  end

  def get
    Faraday.get(
      dataset_url,
      {},
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{token}",
    )
  end

  def update
    metadata = record.metadata.except("identifier")
    Faraday.patch(
      dataset_url,
      metadata.to_json,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{token}",
    )
  end

  def remove
    Faraday.delete(
      dataset_url,
      {},
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{token}",
    )
  end

  def token
    @token ||= begin
      response = Faraday.post(
        "https://#{root_url}/v1/clientauth/get-token",
        Rails.configuration.dm_api.to_json,
        "Content-Type" => "application/json",
      )
      json = JSON.parse(response.body)
      json["token"]
    end
  end

  def root_url
    @root_url ||= Rails.configuration.dm_api_root_url
  end

  def dataset_url
    @dataset_url ||= File.join(datasets_root_url, record.remote_id)
  end

  def datasets_root_url
    @datasets_root_url ||= File.join("https://", root_url, "v1/datasets")
  end
end
