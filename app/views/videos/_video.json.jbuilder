json.extract! video, :id, :playlist_id, :videoid, :title, :downloaded_at, :created_at, :updated_at
json.url video_url(video, format: :json)
