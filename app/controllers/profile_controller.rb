class ProfileController < ApplicationController

  def show
    @profile_data = ProfileData.new(current_user).build_profile_data
  end

end
