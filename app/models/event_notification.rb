class EventNotification < ApplicationRecord
  belongs_to :user
  belongs_to :event

  scope :seen, -> { where(seen: true) }
  scope :not_seen, -> { where(seen: false) }
end
