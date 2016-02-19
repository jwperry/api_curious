require 'rails_helper'

RSpec.feature "UserCanLogIn", vcr: true do
  describe "User can log in with GitHub credentials" do
    it "allows user to log in" do
      visit '/'

      click_on "Login with Github"

      expect(page).to have_content("Profile")
      expect(page).to have_content("jwperry")
      expect(current_path).to eq("/profile")
    end
  end
end
