class GithubService
  attr_reader :connection

  def initialize
    @connection = Faraday.new(url: "https://api.github.com")
  end

  private

  def parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  # def create_song(data)
  #   parse(connection.post("songs", data))
  # end

  # def update_song(data)
  #   parse(connection.patch("songs/#{id}", data))
  # end

  # def destroy_song(id)
  #   parse(connection.delete("songs/#{id}", data))
  # end

end

# Profile pic
# Number of starred repos
# Followers "https://api.github.com/user/followers"
# Following "https://api.github.com/user/following{/target}"