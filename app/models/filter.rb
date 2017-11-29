class Filter < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :user
  has_and_belongs_to_many :cities
  has_and_belongs_to_many :topics

  def process_cities! city_ids
    city_ids_for_delete = cities.pluck(:id) - city_ids
    City.where(id: city_ids_for_delete).each { |city| cities.delete(city) } if city_ids_for_delete.any?
    City.where(id: city_ids).each { |city| cities << city unless cities.where(id: city.id).any? }
  end

  def process_topics! topic_ids
    topic_ids_for_delete = topics.pluck(:id) - topic_ids
    Topic.where(id: topic_ids_for_delete).each { |topic| topics.delete(topic) } if topic_ids_for_delete.any?
    Topic.where(id: topic_ids).each { |topic| topics << topic unless topics.where(id: topic.id).any? }
  end
end
