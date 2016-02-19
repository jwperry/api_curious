class SessionsController < ApplicationController
  before_action :set_mock if Rails.env.test?

  def create
    user = User.find_or_create_by_auth(request.env["omniauth.auth"])
    if user
      session[:user_id] = user.id
      redirect_to profile_path
    else
      redirect_to root_path
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  private

  def set_mock
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  end

end
