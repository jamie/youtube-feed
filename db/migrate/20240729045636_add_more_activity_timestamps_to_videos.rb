class AddMoreActivityTimestampsToVideos < ActiveRecord::Migration[7.1]
  def change
    change_table :videos do |t|
      t.datetime :watched_at
      t.datetime :deleted_at
    end
  end
end
