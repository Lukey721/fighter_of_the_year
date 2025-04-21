# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  # disable CSRF for apis
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
end
