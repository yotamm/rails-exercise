require 'securerandom'

class UsersController < ApplicationController
  DISPLAY_FIELDS = [:first_name, :last_name, :email]
  skip_before_action :verify_authenticity_token
  before_action :set_user_by_token, except: %i[index create sign_in]
  before_action :validate_and_set_user_by_id, only: %i[show update]

  def index
    @users = User.all
    render(json: @users.map{|user| get_display_ready_user(user)})
  end

  def show
    render(json: get_display_ready_user(@user))
  end

  def create
    @user = User.create(permitted_params)
    render_user
  end

  def sign_in
    @user = User.find_by(email: params.fetch(:email, nil))
    head :unauthorized unless user.password == params.fetch(:password)
    set_token
    render(json: get_display_ready_user(@user))
  end

  def update
    @user.update(permitted_params)
    render(json: get_display_ready_user(@user))
  end

  def sign_out
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

  private def validate_and_set_user_by_id
    @user = get_user_by_id
    token = get_token
    head :unauthorized unless @user.token == token
  end

  private def get_token
    cookies[:token]
  end

  private def set_token
    token = SecureRandom.uuid
    @user.update(token: token)
    cookies[:token] = token
  end

  private def set_user_by_token
    token = get_token
    head :unauthorized unless token
    @user = User.find_by(token: token)
    head :unauthorized unless @user
  end

  private def render_user
    if @user.errors
      render(json: @user.errors.full_messages, status: :bad_request)
    else
      render(json: get_display_ready_user(@user))
    end
  end
end
