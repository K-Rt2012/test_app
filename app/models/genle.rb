class Genle < ApplicationRecord
  has_and_belongs_to_many :youtubers
  belongs_to :genle_category
end
