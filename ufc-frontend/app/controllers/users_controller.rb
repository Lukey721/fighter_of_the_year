require 'ostruct'
require 'json'
require 'faraday'

class UsersController < ApplicationController
  # Show the registration form to get a user ID
  def new
    @user = OpenStruct.new 
  end

  # Handle the user registration by sending data to the user-api(backend)
  def create
    response = Faraday.post("http://user-api:3000/users", {
      user: {
        name: params[:user][:name],
        email: params[:user][:email],
        password: params[:user][:password],
        password_confirmation: params[:user][:password_confirmation]
      }
    })

    if response.status == 201
      user_data = JSON.parse(response.body)
      redirect_to thank_you_path(name: user_data["name"], email: user_data["email"])
    else
      flash[:alert] = "Registration failed: #{response.body}"
      @user = OpenStruct.new(params[:user]) # repopulate the form
      render :new
    end
  end

  # Thank you page
  def thank_you
    @name = params[:name]
    @email = params[:email]
  end
end