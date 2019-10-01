class Like < ApplicationRecord
  belongs_to :user
  belongs_to :youtuber
  validates :user_id, presence:true
  validates :youtuber_id, presence:true
end
