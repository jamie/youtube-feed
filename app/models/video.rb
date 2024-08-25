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

  def local_path = "#{ENV["VIDEO_ROOT"]}/#{playlist.title.tr("/", "-")}"

  def youtube_url = "https://youtube.com/watch?v=#{videoid}"

  def stub_on_disk? = Dir["#{local_path.tr("[]", "?")}/*#{shell_date} \\[#{videoid}\\].mp4"].any?

  def on_disk? = !stub_on_disk? && Dir["#{local_path.tr("[]", "?")}/*#{videoid}\\].mp4"].any?

  def shell_date = "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]_[0-9][0-9]"

  def download!
    return if downloaded_at?
    Dir["#{local_path}/*#{videoid}*"].each { FileUtils.rm(_1) }

    quality = "bestvideo[vbr<1200]+bestaudio"
    FileUtils.mkdir_p(local_path)
    puts `cd "#{local_path}" && yt-dlp -f "#{quality}" #{youtube_url}`
    touch(:downloaded_at) if on_disk?
  end

  def delete_local!
    `rm "#{local_path}/"*#{videoid}*`
    touch(:deleted_at)
  end
end
