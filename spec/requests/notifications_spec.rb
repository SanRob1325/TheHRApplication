require 'rails_helper'

RSpec.describe "Notifications API", type: :request do
  let(:notification_manager) { NotificationManager.instance }
  before(:each) do
    NotificationManager.instance.clear_notifications
  end

  describe "GET /notifications" do
    it "returns a list of notifications" do
      notification_manager.add_notification("Test Notification")
      get "/notifications"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(1)
      expect(json_response.first["message"]).to eq("Test Notification")
    end
  end

  describe "POST /notifications" do
    it "creates a new notification" do
      post "/notifications", params: { notification: { message: "Test Notification" } }

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Test Notification")
    end

    it "returns an error if message is blank" do
      post "/notifications", params: { notification: { message: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Message can't be blank")
    end
  end

  describe "DELETE /notifications/:id" do
    it "deletes a specific notification" do
      notification_manager.add_notification("Test Notification")
      notification = notification_manager.all_notifications.first

      delete "/notifications/#{notification[:id]}"

      expect(response).to have_http_status(:no_content)
      expect(notification_manager.all_notifications).to be_empty
    end
  end

  describe "DELETE /notifications" do
    it "clears all the notifications" do
      notification_manager.add_notification("Clear 1")
      notification_manager.add_notification("Clear 2")

      delete "/notifications"
      expect(response).to have_http_status(:no_content)
      expect(notification_manager.all_notifications).to be_empty
    end
  end
end
