class Api::Local::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json
  layout false
end
