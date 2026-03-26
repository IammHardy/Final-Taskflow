class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string  :name,        null: false
      t.string  :slug,        null: false
      t.string  :industry
      t.string  :logo_url
      t.string  :primary_color, default: "#6366f1"
      t.boolean :active,     null: false, default: true
      t.integer :plan,       null: false, default: 0  # free, pro, enterprise
      t.timestamps
    end
    add_index :companies, :slug, unique: true
  end
end