module V1
  class UsersController < ApplicationController
    before_action :authorize_request, except: :create
    before_action :find_user, except: %i[create index]

    def create
      @user = User.new(user_params)

      if @user.save
        render :create
      else
        render json: { errors: @user.errors.full_messages }, status: :unauthorized
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :role, :family_key)
    end
  end
end