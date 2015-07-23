require_relative '../digest_helper'

namespace :digests do
  def digest_helper
    @_digest_helper ||= Citygram::DigestHelper.new
  end

  task send: :app do
    digest_helper.send_notifications
  end

  task send_if_digest_day: :app do
    digest_helper.send_notifications_if_digest_day
  end
end
