class NotificationsController < ApplicationController
  # GET /notifications
  def index
    notifications = NotificationManager.instance.all_notifications
    render json: notifications, status: :ok
  end
  # POST /notifications
  def create
    # Safely extract the message from the nested notification  Reference:https://medium.com/@basemshams30/exploring-the-power-of-dig-in-ruby-navigating-hashes-and-arrays-with-ease-b014a801f5d
    message = params.dig(:notification, :message)

    # Check if the message is present or empty
    if message.present?
      # Adds the notification to the NotificationManager and stores the value
      notification = NotificationManager.instance.add_notification(notification_params[:message])
      # Respons with a created notification with a 201 or 200 HTTP status
      render json: notification, status: :created
    else
      render json: { error: "Message can't be blank" }, status: :unprocessable_entity
    end
  end
  # DELETE /notifications/:id
  def destroy
    # Convert ID from the request parameters to an integer
    id = params[:id].to_i
    # Remove the notification with the given ID using the NotificationManager
    NotificationManager.instance.remove_notification(id)
    # Responds with HTTP 204 No Content to indicate a successful deletion Reference:https://blog.skylight.io/the-lifecycle-of-a-response/#:~:text=In%20Rails%2C%20the%20head%20method,%3Ano_content%20for%20%22204.%22
    head :no_content
  end

  # DELETE /notifications
  def destroy_all
    NotificationManager.instance.clear_notifications
    head :no_content
  end

  private

  # define permitted attributes
  def notification_params
    params.require(:notification).permit(:message)
  end
end
