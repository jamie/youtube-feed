class Video < ApplicationRecord
  belongs_to :playlist

  validates :videoid, uniqueness: true

  scope :to_download, -> { where(downloaded_at: nil) }

  def downloaded? = downloaded_at.present?

  def download!
    # return if downloaded_at?

    path = "#{VIDEO_ROOT}/#{playlist.channel}/#{playlist.title}"
    quality = "bestvideo[vbr<1200]+bestaudio"
    FileUtils.mkdir_p(path)
    puts `cd "#{path}" && yt-dlp -f "#{quality}" "https://youtube.com/watch?v=#{videoid}"`
    touch(:downloaded_at)
  end
end
