require 'json'
require 'faraday'

class AdminController < ApplicationController
  #before_action :authenticate_user!
  #before_action :ensure_admin
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

private
#remove checks while testing
 #def ensure_admin
 # unless current_user && current_user["is_admin"]
  #  flash[:alert] = "You must be an admin to view this page."
   # redirect_to root_path
  #end
 #end
end