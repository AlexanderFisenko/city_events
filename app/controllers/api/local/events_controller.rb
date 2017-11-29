class Api::Local::EventsController < Api::Local::BaseController

  def index
    filter = params[:filter].permit!.to_h
    sql = []

    if filter[:topic_ids].present?
      topic_ids = filter[:topic_ids].split(',')
      sql << "(topics.id in (#{filter[:topic_ids]}))"
    end

    if filter[:city_ids].present?
      city_ids = filter[:city_ids].split(',')
      sql << "(events.city_id in (#{filter[:city_ids]}))"
    end

    if filter[:started_at].present?
      from = filter[:started_at].to_datetime
      sql << "(events.started_at >= '#{from}')"
    end

    if filter[:finished_at].present?
      to = filter[:finished_at].to_datetime
      sql << "(events.finished_at <= '#{to}')"
    end

    sql = sql.join(' AND ')

    @events = EventFacade.new(user_id: current_user.id, sql: sql).get_events

    render json: @events
  end
end
