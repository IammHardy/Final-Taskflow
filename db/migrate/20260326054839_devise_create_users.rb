class DeviseCreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string   :email,              null: false, default: ""
      t.string   :encrypted_password, null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      t.string   :first_name,  null: false, default: ""
      t.string   :last_name,   null: false, default: ""
      t.string   :phone
      t.string   :avatar_url
      t.integer  :role,        null: false, default: 0

      t.references :company, null: true, foreign_key: true
      t.references :sector,  null: true, foreign_key: true

      t.boolean  :active, null: false, default: true
      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :company_id
    add_index :users, :sector_id
  end
end