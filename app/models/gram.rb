class Gram < ApplicationRecord
  belongs_to :user
  mount_uploader :photo, PhotoUploader
  validates :message, presence: true
  validates :photo , presence: true
end
