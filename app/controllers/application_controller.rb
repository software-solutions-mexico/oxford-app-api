class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def find_user
    @user = User.find_by_email!(params[:_email])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Usuario no econtrado' }, status: :not_found
  end

  def comprobe_admin
    head :unauthorized if [current_user&.role&.upcase, current_user&.role&.downcase, current_user&.role&.capitalize] != ["ADMIN","admin","Admin"]
  end

  def permission
    head :unauthorized if current_user&.role != 'ADMIN'
  end
end
