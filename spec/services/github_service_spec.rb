require 'rails_helper'

describe "GitHubService" do

  before do
    @user = User.create(username: "jwperry",
                        uid: ENV['UID'],
                        provider: "github",
                        email: "joseph.w.perry@gmail.com",
                        image_url: "https://avatars.githubusercontent.com/u/13172425?v=3",
                        token: ENV['USER_TOKEN'],
                        name: "Joe Perry")
    @github_service = GithubService.new(@user)
  end

  context "#starred_repos" do
    it "returns starred repositories" do
      VCR.use_cassette("github_service#starred_repos") do
        starred_repos = @github_service.starred_repos
        repo = starred_repos.first
        expect(repo[:name]).to eq("the_pivot")
        expect(repo[:owner][:login]).to eq("jwperry")
        expect(starred_repos.count).to eq(1)
      end
    end
  end

  context "#followers" do
    it "returns followers" do
      VCR.use_cassette("github_service#followers") do
        followers = @github_service.followers
        follower = followers.first
        expect(follower[:login]).to eq("PenneyGadget")
        expect(followers.count).to eq(6)
      end
    end
  end

  context "#following" do
    it "returns users being followed" do
      VCR.use_cassette("github_service#following") do
        following = @github_service.following
        followed = following.first
        expect(followed[:login]).to eq("brantwellman")
        expect(following.count).to eq(2)
      end
    end
  end

  context "#contributions" do
    it "returns contributions in the last year" do
      VCR.use_cassette("github_service#contributions") do
        contributions = @github_service.contributions_in_last_year
        expect(contributions).to eq("297 total")
      end
    end
  end

  context "#longest_streak" do
    it "returns longest contribution streak" do
      VCR.use_cassette("github_service#longest_streak") do
        longest_streak = @github_service.longest_streak
        expect(longest_streak).to eq("15 days")
      end
    end
  end

  context "#current_streak" do
    it "returns current contribution streak" do
      VCR.use_cassette("github_service#current_streak") do
        current_streak = @github_service.current_streak
        expect(current_streak).to eq("3 days")
      end
    end
  end

  context "#organizations" do
    it "returns organizations" do
      VCR.use_cassette("github_service#organizations") do
        organizations = @github_service.organizations
        organization = organizations.first
        expect(organization).to eq(nil)
        expect(organizations.count).to eq(0)
      end
    end
  end

  context "#recent_commits" do
    it "returns user's recent commits" do
      VCR.use_cassette("github_service#recent_commits") do
        commits = @github_service.recent_commits
        commit = commits.last
        expect(commit).to eq("Login via Github functional")
        expect(commits.count).to eq(2)
      end
    end
  end

  context "#recent_following_commits" do
    it "returns up to top five recent commits from followers" do
      VCR.use_cassette("github_service#recent_following_commits") do
        commits = @github_service.recent_following_commits
        first_followed = commits.first
        expect(first_followed[:username]).to eq("brantwellman")
        expect(first_followed[:commits].first).to eq("Basic styling for dashboard")
        expect(first_followed[:commits].count).to eq(12)
      end
    end
  end

  context "#repositories" do
    it "returns repositories" do
      VCR.use_cassette("github_service#repositories") do
        repos = @github_service.repositories
        repo = repos.first
        expect(repo[:name]).to eq("codebreakers")
        expect(repo[:owner][:login]).to eq("GregoryArmstrong")
        expect(repos.count).to eq(30)
      end
    end
  end
end
