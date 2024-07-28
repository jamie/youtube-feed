class Video < ApplicationRecord
  belongs_to :playlist

  validates :videoid, uniqueness: true
end
