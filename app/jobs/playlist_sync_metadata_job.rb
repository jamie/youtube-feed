class PlaylistSyncMetadataJob < ApplicationJob
  queue_as :default

  def perform(playlist)
    playlist.sync_metadata
    playlist.save
  end
end
