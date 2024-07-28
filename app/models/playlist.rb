class Playlist < ApplicationRecord
  after_create_commit ->(){ PlaylistSyncMetadataJob.perform_later(self) }

  def sync_metadata
    return if title.presence && channel.presence

    page = HTTP.get(url)
    js = page.body.to_s.match(%r{<script nonce="[^"]*">var ytInitialData = (.*?);</script>})[1]
    json = JSON.parse(js)

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
end
