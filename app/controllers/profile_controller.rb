class ProfileController < ApplicationController

  def show
    @starred_repos = github_service.starred_repos
    @followers = github_service.followers
    @following = github_service.following
  end

end
