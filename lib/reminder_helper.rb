require 'date'

module Citygram
  class ReminderHelper
    
    def remindables
      Subscription.sms.order(:last_notified).select{ |sub| sub.remindable? }
    end

    def send_notifications
      i = 1
      remindables.paged_each do |subscription|
        Citygram::App.logger.info("Reminding #{subscription.nominative} in #{i} minutes.")
        Citygram::Workers::ReminderNotification.perform_in(i.minutes, subscription.id)
        i = i +1
      end
    end

  end
end
