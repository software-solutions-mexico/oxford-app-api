module V1
  class DevicesController < ApplicationController
    before_action :authorize_request
    before_action :comprobe_admin
    before_action :set_device, only: [:show, :update, :destroy]
    # protect_from_forgery with: :null_session

    # GET /devices
    # GET /devices.json
    def index
      @devices = Device.all
    end

    # GET /devices/1
    # GET /devices/1.json
    def show
    end

    # POST /devices
    # POST /devices.json
    def create
      @device = Device.new(device_params)

      if @device.save
        render 'show'
      else
        render json: @device.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /devices/1
    # PATCH/PUT /devices/1.json
    def update
      if @device.update(device_params)
        render 'show'
      else
        render json: @device.errors, status: :unprocessable_entity
      end
    end

    # DELETE /devices/1
    # DELETE /devices/1.json
    def destroy
      @device.destroy
    end

    def show_by_user
      @user = User.find(device_params[:user_id])
      @devices = @user&.devices
      render 'index'
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:model, :uuid, :token, :platform, :user_id)
    end
  end
end
