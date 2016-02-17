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

  def recent_commits
  end

  private

  def parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end

# def contributions
#   @page = Nokogiri::HTML(open("https://github.com/#{@current_user.nickname}"))
#   @page.xpath("//*[@id='contributions-calendar']/div[3]/span[2]").text
# end