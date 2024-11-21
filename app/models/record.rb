class Record < ApplicationRecord
  before_validation :json_parse_metadata

  validates :name, :metadata, presence: true

  def json_parse_metadata
    return if metadata.blank?
    return if metadata.is_a?(Hash)

    self.metadata = JSON.parse(metadata)
  rescue JSON::ParserError => e
    errors.add :metadata, e.message
  end
end
