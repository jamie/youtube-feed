class PlexSyncJob < ApplicationJob
  queue_as :default

  def perform
    plex_url = "http://#{ENV["PLEX_HOST"]}/library/sections/#{ENV["PLEX_SECTION"]}/all?type=1&sort=lastViewedAt%3Adesc&X-Plex-Token=#{ENV["PLEX_TOKEN"]}"

    uri = URI.parse(plex_url)
    request = Net::HTTP::Get.new(uri)
    request["Accept"] = "application/json"
    response = Net::HTTP.new(uri.host, uri.port).request(request)
    json = JSON.parse(response.body)

    json.dig("MediaContainer", "Metadata").each do |record|
      videoid = record["title"].scan(/\[(.*?)\]/).last[0]
      if record["lastViewedAt"]
        watched_at = Time.at(record["lastViewedAt"].to_i)
        Video.where(videoid:).unwatched.update_all(watched_at:)
      end
    end
  end
end
