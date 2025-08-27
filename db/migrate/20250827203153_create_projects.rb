class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :token, null: false, index: { unique: true }
      t.timestamps null: false
    end
  end
end
