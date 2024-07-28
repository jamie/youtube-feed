require "test_helper"

class PlaylistTest < ActiveSupport::TestCase
  test "sync_metadata" do
    playlist = Playlist.new(url: "https://www.youtube.com/playlist?list=PL6RLee9oArCArCAjnOtZ17dlVZQxaHG8G")

    playlist.sync_metadata

    assert_equal "Group Therapy Radio | Streaming Live Every Friday", playlist.title
    assert_equal "Above & Beyond", playlist.channel
  end
end
