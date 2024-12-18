require "singleton"
class NotificationManager
  include Singleton

  def initialize
    @notifications = []
    @current_id = 0
  end

  def add_notification(message)
    @current_id += 1
    @notifications << { id: @current_id, message: message }
    { id: @current_id, message: message }
  end

  def all_notifications
    @notifications
  end

  def clear_notifications
    @notifications.clear
  end

  def remove_notification(id)
    @notifications.reject! { |notification| notification[:id] == id }
  end
end
