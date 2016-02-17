class ProfileController < ApplicationController

  def show
    @starred_repos = github_service.starred_repos
    @followers = github_service.followers
    @following = github_service.following
    @contributions = github_service.contributions_in_last_year
    @longest_streak = github_service.longest_streak
    @current_streak = github_service.current_streak
  end

end
