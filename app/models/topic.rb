class Topic < ApplicationRecord
  include Concerns::Common

  has_and_belongs_to_many :events

  validates_presence_of :title
end
