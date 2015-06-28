require_relative '../digest_helper'

namespace :digests do
  task send: :app do
    Citygram::DigestHelper.send
  end

  task send_if_digest_day: :app do
    if Citygram::DigestHelper.digest_day?
      Citygram::DigestHelper.send
    end
  end
end
