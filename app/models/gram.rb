class Gram < ApplicationRecord
  belongs_to :user
  has_many :comments
  mount_uploader :photo, PhotoUploader
  validates :message, presence: true
  validates :photo , presence: true
end
