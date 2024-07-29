class YoutubeSyncJob < ApplicationJob
  queue_as :default

  def perform(*)
    Playlist.all.each { PlaylistUpdateVideosJob.perform_now(_1) }
    Video.to_download.each { _1.download! }
  end
end
