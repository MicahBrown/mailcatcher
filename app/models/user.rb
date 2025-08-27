class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_projects, class_name: "User::Project"
  has_many :projects, through: :user_projects

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
