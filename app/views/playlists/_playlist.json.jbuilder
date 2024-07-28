json.extract! playlist, :id, :url, :title, :account, :created_at, :updated_at
json.url playlist_url(playlist, format: :json)
