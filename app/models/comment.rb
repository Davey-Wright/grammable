class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :gram
  validates :message, presence: true
end
