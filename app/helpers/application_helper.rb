module ApplicationHelper
  def timestamp(time)
    time.in_time_zone("Central Time (US & Canada)").strftime("%b %-e, %Y %-l:%M %p")
  end
end
