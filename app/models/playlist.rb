class Playlist < ApplicationRecord
  has_many :videos, dependent: :destroy

  normalizes :url, with: ->(url) { url.strip }

  after_create_commit ->(){ PlaylistSyncMetadataJob.perform_later(self) }
  after_create_commit ->(){ PlaylistUpdateVideosJob.perform_later(self) }

  def sync_metadata
    return if title.presence && channel.presence

    json = playlist_json

    if title.blank?
      self.title = json.dig(
        "header",
        "playlistHeaderRenderer",
        "title",
        "simpleText"
      )
    end
    if channel.blank?
      self.channel = json.dig(
        "header",
        "playlistHeaderRenderer",
        "ownerText",
        "runs",
        0,
        "text"
      )
    end
  end

  def update_videos
    video_list = playlist_json.dig(
      "contents",
      "twoColumnBrowseResultsRenderer",
      "tabs",
      0,
      "tabRenderer",
      "content",
      "sectionListRenderer",
      "contents",
      0,
      "itemSectionRenderer",
      "contents",
      0,
      "playlistVideoListRenderer",
      "contents",
    )

    video_list.first(10).each do |record|
      videoid = record.dig("playlistVideoRenderer", "videoId")
      title = record.dig("playlistVideoRenderer", "title", "runs", 0, "text")

      videos << Video.new(videoid:, title:)
    end
  end

  private

  def playlist_json
    uri = URI.parse(url)
    page = Net::HTTP.get(uri)
    js = page.match(%r{<script nonce="[^"]*">var ytInitialData = (.*?);</script>})[1]
    json = JSON.parse(js)
  end

end
