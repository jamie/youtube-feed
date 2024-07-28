class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.references :playlist, null: false, foreign_key: true
      t.string :videoid
      t.string :title
      t.timestamp :downloaded_at

      t.timestamps
    end
  end
end
