require "singleton"

# Inspiration for singleton design pattern implementation, Reference:https://refactoring.guru/design-patterns/singleton/ruby/example
# Another reference: https://dev.to/samuelfaure/explaining-ruby-s-singleton-class-eigenclass-to-confused-beginners-cep
class NotificationManager
  include Singleton
  # default initialisation
  def initialize
    @notifications = []
    @current_id = 0
  end
  # Creates a new notification along with its associated message and id
  def add_notification(message)
    @current_id += 1
    @notifications << { id: @current_id, message: message }
    { id: @current_id, message: message }
  end
  # display  all notifications
  def all_notifications
    @notifications
  end
  # clears all notifications
  def clear_notifications
    @notifications.clear
  end
  # removes specific notifications
  def remove_notification(id)
    @notifications.reject! { |notification| notification[:id] == id }
  end
end
