class Task < ApplicationRecord
  belongs_to :company
  belongs_to :sector,      optional: true
  belongs_to :creator,     class_name: "User"
  belongs_to :assignee,    class_name: "User", optional: true
  belongs_to :parent_task, class_name: "Task", optional: true
  has_many   :subtasks,    class_name: "Task", foreign_key: :parent_task_id, dependent: :destroy
  has_many   :comments,    dependent: :destroy

  acts_as_tenant :company

  enum :status,   { todo: 0, in_progress: 1, review: 2, done: 3, cancelled: 4 }
  enum :priority, { low: 0, medium: 1, high: 2, urgent: 3 }

  validates :title, presence: true
  validates :status, :priority, presence: true

  scope :overdue,    -> { where("due_date < ? AND status NOT IN (?)", Date.today, [3, 4]) }
  scope :due_today,  -> { where(due_date: Date.today) }
  scope :by_status,  ->(s) { where(status: s) }
  scope :assigned_to, ->(user) { where(assignee: user) }

  before_update :set_completed_at

  private

  def set_completed_at
    self.completed_at = Time.current if done? && completed_at.nil?
    self.completed_at = nil          if !done?
  end
end