class CreateAiSuggestions < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_suggestions do |t|
      t.references :company, null: false, foreign_key: true
      t.references :user,    null: false, foreign_key: true
      t.references :task,    null: true,  foreign_key: true
      t.integer    :kind,    null: false, default: 0  # task_suggestion, priority_update, workload_alert, daily_summary
      t.text       :content, null: false
      t.boolean    :applied, default: false
      t.timestamps
    end
  end
end