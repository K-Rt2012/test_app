class ChangeDataCategoryToVideoCategory < ActiveRecord::Migration[5.2]
  def change
    change_column :video_categories, :category, :integer
  end
end
