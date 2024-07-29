class Video < ApplicationRecord
  belongs_to :playlist

  validates :videoid, uniqueness: true

  scope :current, -> { where(deleted_at: nil) }
  scope :to_download, -> { where(downloaded_at: nil) }
  scope :unwatched, -> { where(watched_at: nil) }
  scope :to_delete, -> { where(watched_at: ..1.week.ago) }

  def downloaded? = downloaded_at.present?

  def watched? = watched_at.present?

  def deleted? = deleted_at.present?

  def local_path = "#{ENV["VIDEO_ROOT"]}/#{playlist.channel}/#{playlist.title}"

  def download!
    return if downloaded_at?

    quality = "bestvideo[vbr<1200]+bestaudio"
    FileUtils.mkdir_p(local_path)
    puts `cd "#{local_path}" && yt-dlp -f "#{quality}" "https://youtube.com/watch?v=#{videoid}"`
    touch(:downloaded_at)
  end

  def delete_local!
    `rm "#{local_path}/"*#{videoid}*`
    touch(:deleted_at)
  end
end
