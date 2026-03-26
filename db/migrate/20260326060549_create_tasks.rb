class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :company,     null: false, foreign_key: true
      t.references :sector,      null: true,  foreign_key: true
      t.references :creator,     null: false, foreign_key: { to_table: :users }
      t.references :assignee,    null: true,  foreign_key: { to_table: :users }
      t.references :parent_task, null: true,  foreign_key: { to_table: :tasks }

      t.string     :title,       null: false
      t.text       :description
      t.integer    :status,      null: false, default: 0
      t.integer    :priority,    null: false, default: 1
      t.date       :due_date
      t.datetime   :completed_at
      t.integer    :position,    default: 0
      t.integer    :ai_priority_score
      t.text       :ai_notes

      t.timestamps
    end

    add_index :tasks, :company_id,   if_not_exists: true
    add_index :tasks, :assignee_id,  if_not_exists: true
    add_index :tasks, :status,       if_not_exists: true
    add_index :tasks, :due_date,     if_not_exists: true
  end
end