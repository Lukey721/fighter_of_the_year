# frozen_string_literal: true

require 'ostruct'
class ApplicationController < ActionController::Base
  helper_method :current_user, :admin_user?

  private

  def current_user
    return unless session[:user_id]

    @current_user ||= OpenStruct.new(
      id: session[:user_id],
      email: session[:user_email],
      is_admin: session[:is_admin]
    )
  end

  def user_signed_in?
    current_user.present?
  end

  def admin_user?
    current_user&.is_admin
  end

  def require_login
    return if user_signed_in?

    redirect_to login_path, alert: 'You must be logged in to access this page.'
  end

  def require_admin
    return if admin_user?

    redirect_to root_path, alert: 'You must be an admin to view this page.'
  end
end
