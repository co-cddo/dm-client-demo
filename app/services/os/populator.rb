class OS::Populator
  def self.call
    OS::SourceRetriever.call.each do |resource_xml|
      new(resource_xml).populate
    end
  end

  attr_reader :xml
  def initialize(xml)
    @xml = xml
  end

  def populate
    metadata = OS::RecordProcessor.metadata_from(source_data: xml)
    record = Record.find_or_initialize_by(name: metadata['supplierIdentifier'], source: :os)
    record.source_data = xml
    record.metadata = metadata
    record.metadata['type'] = 'Data Set' if record.metadata['type'] == 'Dataset'
    record.save
    record
  end
end
