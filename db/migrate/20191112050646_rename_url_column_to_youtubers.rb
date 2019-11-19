class RenameUrlColumnToYoutubers < ActiveRecord::Migration[5.2]
  def change
    rename_column :youtubers, :url, :channel_id
  end
end
