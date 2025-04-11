class ApplicationController < ActionController::Base
  helper_method :current_user, :admin_user?

  private

  def current_user
    @current_user ||= OpenStruct.new(
      id: session[:user_id],
      email: session[:user_email],
      is_admin: session[:is_admin]
    ) if session[:user_id]
  end

  def admin_user?
    current_user&.is_admin
  end

  def require_admin
    unless admin_user?
      redirect_to root_path, alert: "You must be an admin to view this page."
    end
  end
end
