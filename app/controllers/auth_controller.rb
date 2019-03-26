class AuthController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    @user = User.where(email: params[:email]).first
    if @user.blank?
      return render json: { error: 'User not found' }, status: :not_found
    end

    if @user.authenticate(params[:password])
      token = JsonWebToken.encode(id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: {
        token: token,
        exp: time.strftime("%m-%d-%Y %H:%M"),
        id: @user.id
      }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

end
