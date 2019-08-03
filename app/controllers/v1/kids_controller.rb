module V1
  class KidsController < ApplicationController
    before_action :authorize_request
    before_action :permission, only: :create
    before_action :comprobe_admin, only: :index

    def index
      render json: Kid.all.order(name: :asc)
    end

    def create
      @kid = Kid.new(kid_params)

      if @kid.save
        render json: @kid
      else
        render json: @kid.errors, status: :unprocessable_entity
      end
    end

    def show
      @kid = Kid.find(params[:id])
      if @kid && show_kid?
        render json: @kid
      else
        head(:unauthorized)
      end
    end

    def show_by_family_key
      @kids = Kid.where(family_key: params[:family_key])
      if @kids && show_kid?
        render json: @kids.order(name: :asc)
      else
        head(:unauthorized)
      end
    end

    def update
      @kid = Kid.find(params[:id])
      if current_user.is_admin?
        if @kid.update(kid_params)
          render json: @kid
        else
          render json: @kid.errors, status: :unprocessable_entity
        end
      else
        errors.add('User', 'not authorized')
        head :unauthorized
      end
    end

    private

    def kid_params
      params.require(:kid).permit(:name, :grade, :group, :family_key, :campus)
    end

    def permission
      head :unauthorized if current_user&.role != 'admin'
    end

    def show_kid?
      current_user.is_admin? || current_user.kids(where: @kid.id).any?
    end
  end
end