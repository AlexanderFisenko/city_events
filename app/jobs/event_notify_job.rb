class EventNotifyJob < ApplicationJob
  def perform(event)
    user_ids = event.subscribed_user_ids
    User.where(id: user_ids).each do |user|
      EventNotification.create(user_id: user.id, event_id: event.id)
      EventsMailer.notify_user(user, event).deliver_now
    end

    ActionCable.server.broadcast(
      'events',
      event: event,
      for_user_ids: user_ids,
    )
  end
end
