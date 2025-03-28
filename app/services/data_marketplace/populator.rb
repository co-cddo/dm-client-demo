class DataMarketplace::Populator

  def self.record_ids
    @record_ids ||= File.readlines(Rails.root.join('db/seeds/dm-record-id-list.txt')).collect(&:strip)
  end

  def self.call
    record_ids.each do |record_id|
      instance = new(remote_id: record_id)
      instance.find_or_create
    end
  end

  attr_reader :remote_id
  def initialize(remote_id:)
    @remote_id = remote_id
  end

  def metadata
    @metadata ||= DataMarketplaceConnector.get(Record.new(remote_id:)).body
  end

  def json
    @json ||= JSON.parse(metadata)
  end

  def find_or_create
    record = Record.find_or_initialize_by(
      name: json['title'],
      source: :data_marketplace
    )
    record.metadata = metadata
    record.save!
    record
  end
end
