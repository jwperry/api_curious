class ProfileData
  attr_reader :github_service

  def initialize(current_user)
    @github_service = GithubService.new(current_user)
  end

  def build_profile_data
    {
      starred_repos: @github_service.starred_repos,
      followers: @github_service.followers,
      following: @github_service.following,
      contributions: @github_service.contributions_in_last_year,
      longest_streak: @github_service.longest_streak,
      current_streak: @github_service.current_streak,
      organizations: @github_service.organizations,
      recent_commits: @github_service.recent_commits,
      recent_following_commits: @github_service.display_recent_following_commits,
      repositories: @github_service.repositories
    }
  end

end
