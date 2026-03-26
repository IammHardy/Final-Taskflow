class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string     :type,       null: false
      t.references :recipient,  null: false, foreign_key: { to_table: :users }, polymorphic: false
      t.jsonb      :params,     null: false, default: {}
      t.datetime   :read_at
      t.timestamps
    end
    add_index :notifications, [:recipient_id, :read_at]
  end
end