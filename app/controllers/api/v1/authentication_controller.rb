class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:login]
  
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id, role: user.role)
      render json: { token: token, user: { id: user.id, email: user.email, role: user.role } }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
  
  def logout
    # JWT is stateless, so actual logout happens on frontend by removing token
    render json: { message: 'Logged out successfully' }
  end
end