class NotificationsController < ApplicationController
  def index
    notifications = NotificationManager.instance.all_notifications
    render json: notifications, status: :ok
  end

  def create
    message = params.dig(:notification, :message)
    if message.present?
      notification = NotificationManager.instance.add_notification(notification_params[:message])
      render json: notification, status: :created
    else
      render json: { error: "Message can't be blank" }, status: :unprocessable_entity
    end
  end
  def destroy
    id = params[:id].to_i
    NotificationManager.instance.remove_notification(id)
    head :no_content
  end

  def destroy_all
    NotificationManager.instance.clear_notifications
    head :no_content
  end

  private
  def notification_params
    params.require(:notification).permit(:message)
  end
end
