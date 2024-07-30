class PlaylistSyncMetadataJob < ApplicationJob
  queue_as :default

  def perform(playlist)
    return if playlist.title.presence && playlist.channel.presence

    json = playlist.youtube_json

    playlist.title ||= json.dig(
      "header",
      "playlistHeaderRenderer",
      "title",
      "simpleText"
    )

    playlist.channel ||= json.dig(
      "header",
      "playlistHeaderRenderer",
      "ownerText",
      "runs",
      0,
      "text"
    )
  end
end
