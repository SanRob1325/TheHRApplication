class NotificationsController < ApplicationController
  def index
    notifications = NotificationManager.instance.get_notifications
    render json: notifications
  end

  def create
    message = params[:message]
    if message.blank?
      render json: {error: "Message can't be blank"},status: :unprocessable_entity
    else
      NotificationManager.instance.add_notification(message)
      render json: {message: "Message cannot be blank"},status: :created
    end
  end
  def destroy
    notification = NotificationManager.instance.clear_notifications.find { |n| n[:id] == params[:id].to_i }

    if notification
      NotificationManager.instance.remove_notification(notification[:id])
      head :no_content
    end
    render json: { message: "Notification not found"},status: :no_content
  end
end