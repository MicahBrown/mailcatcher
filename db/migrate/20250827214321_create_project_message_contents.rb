class CreateProjectMessageContents < ActiveRecord::Migration[8.0]
  def change
    create_table :project_message_contents do |t|
      t.belongs_to :message, null: false, foreign_key: { to_table: :project_messages }
      t.string :content_type, null: false
      t.text :body
      t.timestamps null: false
    end
  end
end
