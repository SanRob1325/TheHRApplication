require 'rails_helper'

RSpec.describe NotificationManager do
  let(:manager) { NotificationManager.instance }

  it "is a singleton" do
    expect(manager).to eq(NotificationManager.instance)
  end

  it "adds a notification" do
    manager.add_notification("Test Notification")
    expect(manager.get_notifications.size).to eq(1)
    expect(manager.get_notifications.first[:message]).to eq("Test Notification")
  end

  it "clears notifications" do
    manager.add_notification("Test Notification")
    manager.clear_notifications
    expect(manager.get_notifications).to be_empty
  end
end
