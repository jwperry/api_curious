require 'open-uri'

class GithubService
  attr_reader :connection

  def initialize(current_user)
    @current_user = current_user
    @connection = Faraday.new(url: "https://api.github.com") do |faraday|
      # faraday.request :url_encoded
      # faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.params[:access_token] = current_user.token
    end
  end

  def starred_repos
    parse(connection.get("user/starred"))
  end

  def followers
    parse(connection.get("user/followers"))
  end

  def following
    parse(connection.get("user/following"))
  end

  def contributions_in_last_year
    noko_page = Nokogiri::HTML(open("https://github.com/#{@current_user.username}"))
    noko_page.xpath('//*[@id="contributions-calendar"]/div[3]/span[2]').text
  end

  def longest_streak
    noko_page = Nokogiri::HTML(open("https://github.com/#{@current_user.username}"))
    noko_page.xpath('//*[@id="contributions-calendar"]/div[4]/span[2]').text
  end

  def current_streak
    noko_page = Nokogiri::HTML(open("https://github.com/#{@current_user.username}"))
    noko_page.xpath('//*[@id="contributions-calendar"]/div[5]/span[2]').text
  end

  def organizations
    parse(connection.get("users/#{@current_user.username}/orgs"))
  end

  def recent_commits
    events = parse(connection.get("users/#{@current_user.username}/events"))
    select_commits(events)
  end

  def recent_following_commits
    following.map do |user|
      events = parse(connection.get("users/#{user[:login]}/events"))
      {username: user[:login], commits: select_commits(events)}
    end
  end

  def select_commits(events)
    pushes = events.select {|event| event[:type] == "PushEvent"}
    pushes.map do |push|
      push[:payload][:commits].map {|commit| commit[:message]}
    end.flatten
  end

  def display_recent_following_commits
    list = recent_following_commits
    list.map do |user_commit|
      {username: user_commit[:username], commits: user_commit[:commits][0..4]}
    end
  end

  def repositories
    parse(connection.get("user/repos"))
  end

  private

  def parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
