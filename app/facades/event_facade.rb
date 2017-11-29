class EventFacade
  def initialize(data)
    @user = User.find(data[:user_id])
    events = if data[:sql]
               Event.joins(:topics).includes(:city, :topics).where(data[:sql])
             else
               Event.includes(:city, :topics)
             end
    @events = events.limit(60).load # limit(60) for this case
  end

  def generate_gon_data
    {
      events: get_events,
      cities: get_cities,
      filter: get_filter,
      topics: get_topics,
      notifications: get_notifications
    }
  end

  def get_events
    @events.map do |event|
      {
        id: event.id,
        title: event.title,
        started_at: event.started_at.in_time_zone.strftime("%Y-%m-%d %H:%M"),
        finished_at: event.finished_at.in_time_zone.strftime("%Y-%m-%d %H:%M"),
        city: { id: event.city.id.to_s, name: event.city.name },
        topics: event.topics.map { |t| { title: t.title, id: t.id.to_s } }
      }
    end
  end

  private

  def get_filter
    filter = @user.filter
    {
      topic_ids: filter&.topics&.pluck(:id)&.join(', '),
      city_ids: filter&.cities&.pluck(:id)&.join(', '),
      started_at: filter&.started_at&.in_time_zone&.strftime("%Y-%m-%d %H:%M"),
      finished_at: filter&.finished_at&.in_time_zone&.strftime("%Y-%m-%d %H:%M")
    }
  end

  def get_topics
    @events.map { |e| e.topics.map { |t| select_options(t) } }.flatten.uniq
  end

  def get_cities
    @events.map { |e| select_options(e.city) }.uniq
  end

  def get_notifications
    @user.event_notifications.not_seen
  end

  private

  def select_options(object)
    return { label: object.title, value: object.id.to_s } if object.class.to_s == 'Topic'
    return { label: object.name, value: object.id.to_s } if object.class.to_s == 'City'
  end
end
