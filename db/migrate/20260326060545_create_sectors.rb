class CreateSectors < ActiveRecord::Migration[8.0]
  def change
    create_table :sectors do |t|
      t.references :company, null: false, foreign_key: true
      t.string     :name,    null: false
      t.string     :description
      t.string     :color,   default: "#6366f1"
      t.boolean    :active,  null: false, default: true
      t.timestamps
    end
    add_index :sectors, [:company_id, :name], unique: true
  end
end