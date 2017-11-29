class User < ApplicationRecord
  include Concerns::Common

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments
  has_one :filter, dependent: :destroy
  has_many :event_notifications, dependent: :destroy
end
