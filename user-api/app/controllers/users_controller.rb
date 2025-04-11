class UsersController < ApplicationController

  def index
    @users = User.all
    render json: @users
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # Login and generate JWT
  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password]) # bcrypt for password hashing
      token = encode_token(@user.id)  # Generate JWT token
      render json: { token: token }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def update_admin_status
    user = User.find(params[:id])
    Rails.logger.info("Toggling admin status for user: #{user.id}") # Debugging log

    user.update(is_admin: !user.is_admin)

    render json: { message: "User admin status updated." }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

   # JWT encoding (generating the token)
   def encode_token(user_id)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i }  # Set expiration time
    JWT.encode(payload, Rails.application.secret_key_base)
  end
end