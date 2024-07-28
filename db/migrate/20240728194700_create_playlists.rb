class CreatePlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists do |t|
      t.string :url
      t.string :title
      t.string :channel

      t.timestamps
    end
  end
end
