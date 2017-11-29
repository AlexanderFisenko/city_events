class EventsController < ApplicationController
  def index
    facade = EventFacade.new(user_id: current_user.id)
    gon.push(facade.generate_gon_data)
  end

  def show
    @event = Event.find params[:id]
    event_notification = @event.event_notifications.not_seen.where(user: current_user).first
    event_notification.update(seen: true) if event_notification
  end
end
