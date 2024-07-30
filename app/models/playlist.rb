class Playlist < ApplicationRecord
  has_many :videos, dependent: :destroy

  normalizes :url, with: ->(url) { url.strip }

  before_create -> { PlaylistSyncMetadata.perform_now(self) }
  after_create_commit -> { PlaylistUpdateVideosJob.perform_later(self) }

  def youtube_json
    uri = URI.parse(url)
    page = Net::HTTP.get(uri)
    js = page.match(%r{<script nonce="[^"]*">var ytInitialData = (.*?);</script>})[1]
    JSON.parse(js)
  end
end
