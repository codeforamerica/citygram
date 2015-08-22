require 'date'

module Citygram
  class ReminderHelper

    def send_notifications
      i = 1
      Subscription.sms.order(:last_notified).paged_each(rows_per_fetch: 10) do |subscription|
        if !subscription.remindable?
          Citygram::App.logger.info("Not reminding #{subscription.nominative}")
          next
        end
        Citygram::App.logger.info("Reminding #{subscription.nominative} in #{i} minutes.")
        r = Citygram::Workers::ReminderNotification.new
        Citygram::App.logger.debug(r.reminder_message(subscription))
        Citygram::App.logger.debug(r.unsub_message(subscription))
        Citygram::Workers::ReminderNotification.perform_in(i.minutes, subscription.id)
        i = i +1
      end
    end

  end
end
