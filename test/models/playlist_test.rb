require "test_helper"

class PlaylistTest < ActiveSupport::TestCase
  test "sync_metadata" do
    playlist = Playlist.new(url: "https://www.youtube.com/playlist?list=PL6RLee9oArCArCAjnOtZ17dlVZQxaHG8G")

    playlist.sync_metadata

    assert_equal "Group Therapy Radio | Streaming Live Every Friday", playlist.title
    assert_equal "Above & Beyond", playlist.channel
  end

  test "update_videos" do
    playlist = Playlist.create(url: "https://www.youtube.com/playlist?list=PL6RLee9oArCArCAjnOtZ17dlVZQxaHG8G")
    playlist.videos.create(videoid: "EWVdBuR9Cic")

    playlist.update_videos
    playlist.save

    assert_equal 10, playlist.videos.count
    assert_match /Group Therapy/, playlist.videos.last.title
  end
end
