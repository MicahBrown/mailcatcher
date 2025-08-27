class Project::Message < ApplicationRecord
  serialize :to, coder: JSON, type: Array
  serialize :from, coder: JSON, type: Array

  belongs_to :project
  has_many :contents, class_name: "Project::Message::Content", foreign_key: "message_id", dependent: :destroy

  def to=(value)
    super(value.blank? ? [] : Array(value))
  end

  def from=(value)
    super(value.blank? ? [] : Array(value))
  end
end
