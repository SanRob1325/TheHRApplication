require 'rails_helper'

RSpec.describe "Notifications API", type: :request do
  before(:each) do
    NotificationManager.instance.clear_notifications
  end

  describe "GET /notifications" do
    it "returns a list of notifications" do
      NotificationManager.instance.add_notification("Test Notification")
      get "/notifications"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "POST /notifications" do
    it "creates a new notification" do
      post "/notifications", params: { message: "Test Notification" }
      expect(response).to have_http_status(:created)
      expect(NotificationManager.instance.get_notifications.size).to eq(1)
    end

    it "returns an error if message is blank" do
      post "/notifications", params: { message: "" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /notifications/:id" do
    it "deletes a specific notification" do
      NotificationManager.instance.add_notification("Test Notification")
      notification = NotificationManager.instance.get_notifications.first

      delete "/notifications/#{notification[:id]}"

      expect(response).to have_http_status(:no_content)
      expect(NotificationManager.instance.get_notifications).to be_empty
    end
  end

  describe "DELETE /notifications" do
    it "clears all the notifications" do
      NotificationManager.instance.add_notification("Clear Me")
      NotificationManager.instance.add_notification("Clear Me Too")
      delete "/notifications/id"
      expect(response).to have_http_status(:no_content)
      expect(NotificationManager.instance.get_notifications).to be_empty
    end
  end
end
