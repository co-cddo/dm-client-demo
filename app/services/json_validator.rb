class JsonValidator
  JSON_SCHEMA_PATH = "https://co-cddo.github.io/data-catalogue-metadata/schema/dataset_schema.json".freeze

  def self.valid?(json)
    new(json).valid?
  end

  attr_reader :json

  def initialize(json)
    @json = json
  end

  def report
    @report ||= JSON::Validator.fully_validate(JSON_SCHEMA_PATH, json)
  end

  def valid?
    report.empty?
  end
end
