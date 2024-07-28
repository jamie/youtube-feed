class PlaylistUpdateVideosJob < ApplicationJob
  queue_as :default

  def perform(playlist)
    playlist.update_videos
    playlist.save
  end
end
