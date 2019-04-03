module V1
  class UsersController < ApplicationController
    before_action :authorize_request, except: :create
    before_action :find_user, except: %i[create index]

    def index
      @users = User.all
      render json: @users, status: :ok
    end

    def show
      render json: @user, status: :ok
    end

    def create
      @user = User.new(user_params)
      if @user.save
        render json: @user, status: :created
      else
        respond_with_error('unprocessable_entity', @user)
      end
    end

    def update
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        respond_with_error('unprocessable_entity', @user)
      end
    end

    def destroy
      @user.destroy
    end

    private

    def find_user
      @user = User.find(params[:id])
      rescue Mongoid::Errors::DocumentNotFound
        respond_with_error('not_found')
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end