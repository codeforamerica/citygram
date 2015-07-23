require 'spec_helper'

describe Citygram::DigestHelper do
  describe "send_notifications_if_digest_day" do
    context 'when digest_day is today' do
      it 'sends the digest' do
        allow_any_instance_of(Citygram::DigestHelper).to receive(:digest_day?).and_return(true)
        expect_any_instance_of(Citygram::DigestHelper).to receive(:send_notifications)

        subject.send_notifications_if_digest_day
      end
    end

    context 'when digest_day is not today' do
      it 'does not send the digest' do
        allow_any_instance_of(Citygram::DigestHelper).to receive(:digest_day?).and_return(false)
        expect_any_instance_of(Citygram::DigestHelper).not_to receive(:send_notifications)

        subject.send_notifications_if_digest_day
      end
    end
  end
end
