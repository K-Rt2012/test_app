class AddColumnRanksYoutubersId < ActiveRecord::Migration[5.2]
  def change
    add_column :ranks, :youtuber_id, :integer
  end
end
