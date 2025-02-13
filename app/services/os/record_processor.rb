class OS::RecordProcessor
  MAPPING_FILE = File.expand_path('os_to_dm_mapping.yml', __dir__)
  SUPPLEMENTARY = {
    status: 'Draft',
    securityClassification: "OFFICIAL",
    accessRights: "OPEN",
  }.stringify_keys


  attr_reader :source_data

  def self.metadata_from(source_data:)
    new(source_data:).metadata
  end

  def initialize(source_data:)
    @source_data = source_data
  end

  def metadata
    matadata ||= extract_metadata_from_source_data(mapping).merge(SUPPLEMENTARY)
  end

  private

  def extract_metadata_from_source_data(map_segment)
   map_segment.each_with_object({}) do |(json_key, xml_path), output|
      next if xml_path.length < 1
      output[json_key] = if xml_path.is_a?(Array)
        xml_path.collect {|v| extract_metadata_from_source_data(v)}.flatten
      else
        results = extract_from_source_doc(xml_path)
        results = results.first if results.length == 1
        results
      end
    end
  end

  def mapping
    @mapping ||= YAML.load_file(MAPPING_FILE)
  end

  def source_doc
    @source_doc ||= Nokogiri::XML(source_data)
  end

  def extract_from_source_doc(path)
    target = path.include?("@") ? :values : :text
    source_doc.xpath(path).collect(&target).flatten
  end
end
