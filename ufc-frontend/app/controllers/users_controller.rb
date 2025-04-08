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
        email: params[:user][:email]
      }
    })

    if response.status == 201
      user_data = JSON.parse(response.body)
      redirect_to thank_you_path(name: user_data["name"], email: user_data["email"])
    else
      flash[:alert] = "Registration failed"
      render :new
    end
  end

  # Thank you page after successful registration
  def thank_you
    @name = params[:name]
    @email = params[:email]
  end
end