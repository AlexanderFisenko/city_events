class EventsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from 'events'
  end
end
