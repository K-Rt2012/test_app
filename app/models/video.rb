class Video < ApplicationRecord
  # videoモデルはvideo_categoryモデルに従属している(1対多の関係)
  #belongs_to :video_category
end
