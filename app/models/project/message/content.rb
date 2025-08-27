class Project::Message::Content < ApplicationRecord
  belongs_to :message, class_name: "Project::Message", foreign_key: "message_id"

  validates :content_type, presence: true
end
