class Api::Local::EventNotificationsController < Api::Local::BaseController
  def make_seen
    user_id = params[:user_id]
    event_id = params[:event_id]
    event_notification = EventNotification.find_by(event_id: event_id, user_id: user_id, seen: false)
    event_notification.update seen: true

    render json: { success: true }
  end
end
