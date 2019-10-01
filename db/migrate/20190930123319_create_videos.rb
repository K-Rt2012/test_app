class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.string :video_id
      t.references :video_category
      t.references :youtuber
      t.string :video_title

      t.timestamps
    end
  end
end
