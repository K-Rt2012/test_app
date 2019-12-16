class GenleCategory < ApplicationRecord
  has_many :genles, dependent: :destroy
end
