class AddProfileColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string, null: false, default: ""
    add_column :users, :last_name,  :string, null: false, default: ""
    add_column :users, :phone,      :string
    add_column :users, :avatar_url, :string
    add_column :users, :role,       :integer, null: false, default: 0
    add_column :users, :active,     :boolean, null: false, default: true

    add_reference :users, :company, null: true, foreign_key: true
    add_reference :users, :sector,  null: true, foreign_key: true
  end
end