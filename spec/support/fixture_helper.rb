def json_from_fixture(path)
  JSON.parse(File.read(fixture_file_upload(path)))
end
