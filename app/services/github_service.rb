require 'open-uri'

class GithubService
  attr_reader :connection

  def initialize(current_user)
    @current_user = current_user
    @connection = Faraday.new(url: "https://api.github.com")
  end

  def starred_repos
    parse(connection.get("user/starred", {access_token: @current_user.token}))
  end

  def followers
    parse(connection.get("user/followers", {access_token: @current_user.token}))
  end

  def following
    parse(connection.get("user/following", {access_token: @current_user.token}))
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
    parse(connection.get("user/orgs", {access_token: @current_user.token}))
  end

  def recent_commits
    events = parse(connection.get("users/#{@current_user.username}/events", {access_token: @current_user.token}))
    select_commits(events)
  end

  def recent_following_commits
    tester = following.map do |user|
      events = parse(connection.get("users/#{user[:login]}/events", {access_token: @current_user.token}))
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

  private

  def parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
