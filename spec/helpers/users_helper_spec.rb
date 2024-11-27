require "rails_helper"

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, type: :helper do
  describe "#login_button" do
    it "displays link to log in" do
      expect(helper.login_button).to include(user_google_oauth2_omniauth_authorize_path)
    end
  end

  describe "#logout_button" do
    it "displays link to log out" do
      expect(helper.logout_button).to include(destroy_user_session_path)
    end
  end
end
