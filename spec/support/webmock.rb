require "webmock/rspec"

# Allow calls to JSON schema
WebMock.disable_net_connect!(allow: "https://co-cddo.github.io")
