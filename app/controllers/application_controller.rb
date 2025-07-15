class ApplicationController < ActionController::API
  before_action :authenticate_request
  
  private
  
  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Unauthorized' }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
  
  def authorize_admin
    render json: { error: 'Admin access required' }, status: :forbidden unless @current_user&.admin?
  end
end