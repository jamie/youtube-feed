class PlaylistUpdateVideosJob < ApplicationJob
  queue_as :default

  def perform(playlist)
    video_list = playlist.youtube_json.dig(
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
      "contents"
    )

    video_list.first(10).reverse_each do |record|
      videoid = record.dig("playlistVideoRenderer", "videoId")
      title = record.dig("playlistVideoRenderer", "title", "runs", 0, "text")

      # NB: Unique validation will prevent duplicates
      playlist.videos.create(videoid:, title:)
    end
  end
end
