class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :sectors, dependent: :destroy
  has_many :tasks, dependent: :destroy

  enum :plan, { free: 0, pro: 1, enterprise: 2 }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/ }

  before_validation :generate_slug, on: :create

  def to_param = slug

  private

  def generate_slug
    self.slug ||= name.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-\z/, "") if name
  end
end