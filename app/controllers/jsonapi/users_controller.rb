module Jsonapi
  class UsersController < Jsonapi::ResourceController
    before_action :authenticate_request

    def index
      if params['me']
        render json: serialize(@current_user), status: :ok if @current_user == context[:current_user]
      else
        super
      end
    end

    private

    def serialize(user)
      JSONAPI::ResourceSerializer.new(Jsonapi::UserResource).serialize_to_hash(Jsonapi::UserResource.new(user))
    end
  end
end
