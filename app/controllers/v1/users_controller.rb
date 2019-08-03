module V1
  class UsersController < ApplicationController
    before_action :authorize_request, except: :create
    before_action :comprobe_admin, only: :index

    def index
      render json: User.all.order(email: :asc)
    end

    def create
      @user = User.new(user_params)

      if @user.save
        render :create
      else
        render json: { errors: @user&.errors.full_messages }, status: :unauthorized
      end
    end

    def update
      @user = User.find(params[:id])
      if current_user.is_admin? || @user&.id == current_user.id
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      else
        errors.add('User', 'not authorized')
        head :unauthorized
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :role, :family_key)
    end
  end
end