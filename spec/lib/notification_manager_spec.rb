require 'rails_helper'

RSpec.describe NotificationManager do
  subject(:manager) { NotificationManager.instance }

  it "is a singleton" do
    expect(manager).to eq(NotificationManager.instance)
  end

  it "adds a notification" do
    notification = manager.add_notification("Test Notification")
    expect(manager.all_notifications).to include(notification)
  end

  it "removes a notification" do
    notification = manager.add_notification("Test Notification")
    manager.remove_notification(notification[:id])
    expect(manager.all_notifications).not_to include(notification)
  end

  it "clears all notifications" do
    manager.add_notification("Test Notification")
    manager.add_notification("Test Notification2")
    manager.clear_notifications
    expect(manager.all_notifications).to be_empty
  end
end
