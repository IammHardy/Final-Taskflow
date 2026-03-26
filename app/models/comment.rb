class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user
  belongs_to :company

  acts_as_tenant :company

  validates :body, presence: true
end