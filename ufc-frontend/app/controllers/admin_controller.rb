require 'json'
require 'faraday'

class AdminController < ApplicationController

 before_action :require_admin

 def users
  response = Faraday.get("http://user-api:3000/users")

  if response.status == 200
    @users = JSON.parse(response.body)
  else
    flash[:alert] = "Could not fetch users."
    @users = []
  end
 end

 def update
  user_id = params[:id]

  response = Faraday.patch("http://user-api:3000/users/#{user_id}/update_admin_status")
  Rails.logger.info "User API responded with status: #{response.status}"
  Rails.logger.info "Response body: #{response.body}"
  
  if response.success?
    redirect_to admin_users_path, notice: "User admin status updated successfully."
  else
    flash[:alert] = "Failed to update admin status."
    redirect_to admin_users_path
  end
 end

 def destroy
  user_id = params[:id]

  response = Faraday.delete("http://user-api:3000/users/#{user_id}")
  
  if response.success?
    redirect_to admin_users_path, notice: "User deleted successfully."
  else
    flash[:alert] = "Failed to delete user."
    redirect_to admin_users_path
  end
 end

end