class Record < ApplicationRecord
  before_validation :json_parse_metadata, :store_metadata_validation

  validates :name, :metadata, presence: true

  def published?
    remote_id?
  end

  def json_parse_metadata
    return if metadata.blank?
    return if metadata.is_a?(Hash)

    self.metadata = JSON.parse(metadata)
  rescue JSON::ParserError => e
    errors.add :metadata, e.message
  end

  def store_metadata_validation
    self.json_valid = JsonValidator.valid?(metadata)
  end
end
