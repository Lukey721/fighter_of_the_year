class ApplicationController < ActionController::API
  # disable CSRF for apis
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
end
