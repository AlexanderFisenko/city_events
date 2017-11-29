class Event < ApplicationRecord
  include Concerns::Common
  # include ChewyKiqqer::Mixin
  # async_update_index index: 'events_search_index#event'

  attr_accessor :skip_callback

  has_and_belongs_to_many :topics
  belongs_to :city
  has_many :comments, dependent: :destroy
  has_many :event_notifications, dependent: :destroy

  validates_presence_of :title, :started_at, :finished_at

  after_create :notify_users, unless: :skip_callback

  def subscribed_user_ids
    sql = []

    # cities
    sql << "( c_f.city_id IS NULL OR c_f.city_id = #{city_id} )"

    # topics
    topic_ids = topics.pluck(:id)
    topic_cond = '( f_t.topic_id IS NULL '
    topic_cond << "OR f_t.topic_id IN (#{topic_ids.join(', ')}) " if topic_ids.present?
    topic_cond << ')'
    sql << topic_cond

    # started_at
    sql << "( filters.started_at IS NULL OR filters.started_at <= '#{started_at.to_datetime}')"

    # finished_at
    sql << "( filters.finished_at IS NULL OR filters.finished_at >= '#{finished_at.to_datetime}' )"

    sql = sql.join(' AND ')

    Filter.joins('LEFT JOIN cities_filters c_f ON c_f.filter_id = filters.id')
          .joins('LEFT JOIN filters_topics f_t ON f_t.filter_id = filters.id')
          .where(sql)
          .pluck('filters.user_id')
  end

  private

  def notify_users
    Rails.env.production? ? EventNotifyJob.perform_later(self) : EventNotifyJob.perform_now(self)
  end
end
