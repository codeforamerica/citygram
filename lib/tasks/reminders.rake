require_relative '../reminder_helper'

namespace :reminders do
  def reminder_helper
    @_reminder_helper ||= Citygram::ReminderHelper.new
  end

  desc "Send daily SMS reminder prompts"
  task send: :app do
    reminder_helper.send_notifications
  end

end
