class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company, optional: true
  belongs_to :sector,  optional: true

  has_many :created_tasks,  class_name: "Task", foreign_key: :creator_id, dependent: :nullify
  has_many :assigned_tasks, class_name: "Task", foreign_key: :assignee_id, dependent: :nullify
  has_many :comments, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  acts_as_tenant :company

  enum :role, { employee: 0, manager: 1, admin: 2, super_admin: 3 }

  validates :first_name, :last_name, presence: true
  validates :role, presence: true
  validates :company, presence: true, unless: :super_admin?

  def full_name = "#{first_name} #{last_name}"
  def initials  = "#{first_name[0]}#{last_name[0]}".upcase

    def superadmin? = super_admin?

  def manager_or_above? = manager? || admin? || super_admin?
  def admin_or_above?   = admin? || super_admin?
end