class NotificationManager
  include Singleton

  def initialize
    @notifications = []
    @next_id = 1
  end

  def add_notification(message)
    @notifications << {id: @next_id, message: message}
    @next_id += 1
  end

  def get_notifications
    @notifications
  end

  def clear_notifications
    @notifications.clear
  end

  def remove_notifications
    @notifications.reject! { |notification| notification[:id] == id}
  end
end