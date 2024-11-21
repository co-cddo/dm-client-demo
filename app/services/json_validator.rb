class JsonValidator
  JSON_SCHEMA_PATH = "https://co-cddo.github.io/data-catalogue-metadata/schema/dataset_schema.json".freeze

  def self.valid?(json)
    new(json).valid?
  end

  attr_reader :json

  def initialize(json)
    @json = json
  end

  def valid?
    JSON::Validator.validate JSON_SCHEMA_PATH, json
  end
end
