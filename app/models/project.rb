class Project < ApplicationRecord
  has_secure_token

  has_many :messages, class_name: "Project::Message", dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def build_message(attributes = {})
    contents = attributes.delete(:content)
    attachments = attributes.delete(:attachments)
    message = messages.build(attributes)
    contents.each do |content_type, body|
      message.contents.build(content_type: content_type, body: body, message: message)
    end

    attachments.present? && attachments.each do |attachment|
      message.attachments.attach(
        io: StringIO.new(attachment[:content]),
        filename: attachment[:filename],
        content_type: attachment[:content_type].split(";").first
      )
    end

    message
  end
end
