class EventsMailer < ApplicationMailer
  def notify_user(user, event)
    @user = user
    @event = event
    @url  = Rails.application.routes.url_helpers.event_url(id: event.id)
    mail(to: @user.email, subject: 'Visit new event')
  end
end
