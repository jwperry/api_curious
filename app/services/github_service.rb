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

  private

  def parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
