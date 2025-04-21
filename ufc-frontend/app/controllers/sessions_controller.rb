# frozen_string_literal: true

class SessionsController < ApplicationController
  def login
    # renders login form
  end

  def create
    response = Faraday.post('http://user-api:3000/login') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        email: params[:email],
        password: params[:password]
      }.to_json
    end

    if response.status == 200
      user = JSON.parse(response.body)
      session[:auth_token] = user['token']
      session[:user_email] = user['email']
      session[:user_id] = user['id']
      session[:is_admin] = user['is_admin']
      redirect_to root_path, allow_other_host: true, notice: "Logged in as #{user['email']}"
    else
      flash.now[:alert] = 'Invalid email or password'
      render :login, status: :unauthorized
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Logged out'
  end
end
