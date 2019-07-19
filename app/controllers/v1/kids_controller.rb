module V1
  class KidsController < ApplicationController
    before_action :authorize_request, except: :create
    before_action :permission, only:  :create

    def create
      @kid = Kid.new(kid_params)

      if @kid.save
        render :create
      else
        head(:unprocessable_entitty)
      end
    end

    private

    def kid_params
      params.require(:user).permit(:name, :grade, :group, :family_key)
    end

    def permission
      render json: { errors: e.message }, status: :unauthorized if current_user.role != 'admin'
    end
  end
end