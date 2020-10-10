class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @users = User.all
        render json: @users
    end

    def show
        @user = User.find_by(id: params[:id]) or not_found
    end

    def new
    end

    def create
        @user = User.create(params.require(:user).permit(:first_name, :last_name, :email))
        render json: @user
    end
end
