require 'securerandom'

class UsersController < ApplicationController
  DISPLAY_FIELDS = [:first_name, :last_name, :email]
  skip_before_action :verify_authenticity_token

  def index
    @users = User.all
    render(json: @users.map{|user| get_display_ready_user(user)})
  end

  def show
    @user = get_user_by_id
    render(json: get_display_ready_user(@user)) if validate_user
  end

  def create
    @user = User.create!(permitted_params)
    render(json: get_display_ready_user(@user))
  end

  def sign_in
    @user = User.find_by(email: params.fetch(:email, nil))
    permission_denied_error unless user.password == params.fetch(:password)
    set_token(user)
    render(json: get_display_ready_user(@user))
  end

  def update
    @user = get_user_by_id
    user.update(permitted_params) if validate_user
    render(json: get_display_ready_user(@user))
  end

  def sign_out
    @user = User.find_by(token: get_token)
    user.update(token: nil)
    cookies.clear
  end

  private def get_display_ready_user(user)
    user.as_json(only: DISPLAY_FIELDS)
  end

  private def permitted_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  private def get_user_by_id
    User.find_by(id: params.fetch(:id, nil))
  end

  private def validate_user
    not_found_error unless @user
    permission_denied_error unless @user.token == get_token
    true
  end

  private def get_token
    cookies[:token]
  end

  private def set_token(user)
    token = SecureRandom.uuid
    user.update(token: token)
    cookies[:token] = token
  end
end
