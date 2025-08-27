class CreateUserProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :user_projects do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :project, null: false, foreign_key: true
      t.timestamps null: false
      t.index [:user_id, :project_id], unique: true
    end
  end
end
