require 'securerandom'

class UsersController < ApplicationController
  DISPLAY_FIELDS = [:first_name, :last_name, :email]
  skip_before_action :verify_authenticity_token

  def index
    users = User.all
    render(json: users.map{|user| get_display_ready_user(user)})
  end

  def show
    user = User.find_by(id: params[:id])
    if user
      render(json: get_display_ready_user(user))
    else
      not_found
    end
  end

  def new
  end

  def create
    user = User.create!(params.require(:user).permit(:first_name, :last_name, :email, :password))
    render(json: get_display_ready_user(user))
  end

  def sign_in
    user = User.find_by(email: params.fetch(:email))
    if user.password == params.fetch(:password)
      token = SecureRandom.uuid
      user.update(token: token)
      session[:token] = token
      render(json: get_display_ready_user(user))
    end
  end

  def update
    user = User.find_by(id: params.fetch(:id))
    user.update(params.require(:user).permit(:first_name, :last_name, :email, :password)) if (user && user.token == session[:token])
    render(json: get_display_ready_user(user))
  end

  private def get_display_ready_user(user)
    user.as_json(only: DISPLAY_FIELDS)
  end
end
