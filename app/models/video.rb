class Video < ApplicationRecord
  # youtuberモデルはvideo_categoryモデルに従属している(1対多の関係)
  belongs_to :youtuber
end
