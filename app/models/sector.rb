class Sector < ApplicationRecord
  belongs_to :company
  has_many :users
  has_many :tasks

  acts_as_tenant :company

  validates :name, presence: true, uniqueness: { scope: :company_id }
end