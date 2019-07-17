class V1::SessionsController < ApplicationController
  before_action :authorize_request, except: :create

  def show
    @user = current_user

    current_user ? head(:ok) : head(:unauthorized)
  end

  def create
    @user = User.where(email: params[:email]).first

    if @user&.valid_password?(params[:password])
      jwt = JWT.encode(
          { user_id: @user.id, exp: (Time.now + 2.weeks).to_i, email: @user.email },
          ENV["SECRET_KEY_BASE"],
          'HS256'
      )

      render :create, locals: { token: jwt }, status: :ok
    else
      head(:unauthorized)
    end
  end


  def destroy
    current_user&.authentication_token = nil
    if current_user&.save
      head(:ok)
    else
      head(:unauthorized)
    end
  end
end