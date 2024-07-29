class CleanupOldJob < ApplicationJob
  queue_as :default

  def perform
    Video.to_delete.each do |video|
      video.delete_local!
    end
  end
end
