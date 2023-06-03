module Jsonapi
  class SessionsController < Jsonapi::ResourceController
    skip_before_action :set_current_user

    def create
      user = User.find_for_authentication(params[:username])

      if user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)

        render json: { access_token: token, user_id: user.id }
      else
        render json: { errors: 'Invalid username or password' }, status: :unauthorized
      end
    end

    def current_user
      return unless decoded_auth_token

      User.find(decoded_auth_token[:user_id])
    end
  end
end
