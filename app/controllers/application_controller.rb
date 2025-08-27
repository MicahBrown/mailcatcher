class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def authorize!(project)
    return project if Current.user&.admin? || Current.user&.projects&.include?(project)

    not_authorized!
  end

  def not_authorized!
    raise "not_authorized"
  end
end
