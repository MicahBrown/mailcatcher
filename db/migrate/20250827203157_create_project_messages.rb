class CreateProjectMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :project_messages do |t|
      t.belongs_to :project, null: false, foreign_key: true
      t.string :to, null: false
      t.string :from, null: false
      t.string :subject
      t.timestamps null: false
    end
  end
end
