require 'spec_helper'

describe Citygram::Models::Subscription do
  it 'belongs to a publisher' do
    publisher = create(:publisher)
    subscription = create(:subscription, publisher: publisher).reload
    expect(subscription.publisher).to eq publisher
  end

  it 'whitelists mass-assignable attributes' do
    expect(Subscription.allowed_columns.sort).to eq [:geom, :publisher_id, :channel, :webhook_url, :phone_number, :email_address].sort
  end

  it 'round trip a geojson geometry through a postgis geometry column' do
    geojson = fixture('subject-geom.geojson')
    subscription_id = create(:subscription, geom: geojson).id
    subscription = Subscription.first!(id: subscription_id)
    expect(subscription.geom).to eq geojson
  end

  it 'requires a valid GeoJSON feature geometry' do
    subscription = build(:subscription, geom: fixture('invalid-geom.geojson'))
    expect(subscription).not_to be_valid
  end

  it 'requires an available channel' do
    subscription = build(:subscription, channel: 'missing')
    expect(subscription).not_to be_valid
  end

  it 'has_events? is false when subscription has no events' do
    subscription = create(:subscription)
    expect(subscription).to_not have_events
  end

  it 'has_events? is true when subscription has events' do
    subscription = create(:subscription)
    create(:event, publisher: subscription.publisher, geom: subscription.geom)
    expect(subscription).to have_events
  end

  describe 'determining notifiables' do
    it 'includes subscriptions that are not unsubscribed' do
      subscription = create(:subscription, unsubscribed_at: nil)
      expect(Subscription.notifiables.all).to eq [subscription]
    end

    it 'excludes subscriptions that are unsubscribed' do
      subscription = create(:subscription, unsubscribed_at: Date.today)
      expect(Subscription.notifiables.all).to be_empty
    end

    it 'includes subscriptions with active publishers' do
      publisher = create(:publisher, active: true)
      subscription = create(:subscription, publisher: publisher).reload
      expect(Subscription.notifiables.all).to eq [subscription]
    end

    it 'excludes subscriptions with inactive publishers' do
      publisher = create(:publisher, active: false)
      create(:subscription, publisher: publisher)
      expect(Subscription.notifiables.all).to be_empty
    end
  end

  describe 'contact channel validations' do
    context 'webhook' do
      it 'requires the contact to be a valid url' do
        subscription = build(:subscription, channel: 'webhook', webhook_url: 'human@example.com')
        expect(subscription).not_to be_valid
      end
    end

    context 'sms' do
      it 'requires the contact to be a valid phone number' do
        subscription = build(:subscription, channel: 'sms', phone_number: '555-5555')
        expect(subscription).not_to be_valid
      end
    end

    context 'email' do
      it 'requires the contact to be a valid email address' do
        subscription = build(:subscription, channel: 'email', email_address: '+16024100680')
        expect(subscription).not_to be_valid
      end
    end
  end
  
  describe 'activity evaluation', focus: true do
    it 'should be the creation date when unevaluated' do
      subscription = build(:subscription, channel: 'sms', phone_number: '555-5555')
      expect(subscription.last_notification).to eq(subscription.created_at)
    end
    it 'should be an assignable field' do
      ntime = 2.weeks.ago
      subscription = build(:subscription, channel: 'sms', phone_number: '555-5555', last_notified: ntime)
      expect(subscription.last_notification).to eq(ntime)
    end
    it 'should not be required within 2 weeks' do
      subscription = build(:subscription, channel: 'sms', phone_number: '555-5555', last_notified: 1.weeks.ago)
      expect(subscription.needs_activity_evaluation?).not_to eq(true)
    end
    it 'should be required after 2 weeks' do
      subscription = build(:subscription, channel: 'sms', phone_number: '555-5555', last_notified: 3.weeks.ago)
      expect(subscription.needs_activity_evaluation?).to eq(true)
    end
        
    context 'measuring deliveries' do
      
      let(:subscription){ build(:subscription, channel: 'sms', phone_number: '555-5555', last_notified: 3.weeks.ago) }
      let(:expected_opts){ {after_date: subscription.last_notified} }
      it "should reference event count" do
        expect(Event).to receive(:from_subscription).with(subscription, expected_opts)
        subscription.deliveries_since_last_notification
      end
      
      context 'action' do
        
        it "should not be required at 27 messages" do
          allow(subscription).to receive(:deliveries_since_last_notification){ 27 }
          expect(subscription.requires_notification?).not_to eq(true)
        end
        
        it "should be required at 28 messages" do
          allow(subscription).to receive(:deliveries_since_last_notification){ 28 }
          expect(subscription.requires_notification?).to eq(true)
        end
        
      end
      
    end
    
  end

  describe 'notification message', focus: true do
    
    before(:each) do
      @subscription = build(:subscription, last_notified: 3.weeks.ago)
      allow(@subscription).to receive(:deliveries_since_last_notification){ 28 }
    end
    
    subject{ @subscription.notification_message }

    it "should include activity" do
      expect(subject).to match("28")
    end
    
    it "should include publisher title" do
      expect(subject).to match(@subscription.publisher.title)
    end
    
    it "should include publisher city" do
      expect(subject).to match(@subscription.publisher.city)
    end
    
    it "shoud include a date format" do
      expect(subject).to match(@subscription.last_notification.strftime("%b %d, %Y"))
    end
    
    it "should be shortish" do
      expect(subject.length).to be <= 140
    end
    
    it "should include an information link"
    
  end
end
