module V1
  class CampusController < ApplicationController
    before_action :authorize_request
    before_action :comprobe_admin, only: :create
    before_action :set_campus, only: [:show, :update, :destroy]

    # GET /v1/campus
    # GET /v1/campus.json
    def index
      @campus = Campus.all
    end

    # GET /v1/campus/1
    # GET /v1/campus/1.json
    def show
    end

    def show_by_name
      @campus = Campus.where(name: params['names'])
      render :show
    end

    # POST /v1/campus
    # POST /v1/campus.json
    def create
      @campus = Campus.new(campus_params)

      if @campus.save
        render :show, status: :created, location: @campus
      else
        render json: @campus.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /v1/campus/1
    # PATCH/PUT /v1/campus/1.json
    def update
      if @campus.update(campus_params)
        render :show, status: :ok, location: @campus
      else
        render json: @campus.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/campus/1
    # DELETE /v1/campus/1.json
    def destroy
      @campus.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_campus
        @campus = Campus.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def campus_params
        params.require(:campus).permit(:name, :groups)
      end
  end
end