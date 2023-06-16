module Api
  module V1
    class BaseController < ActionController::API
      rescue_from Error::EmptyToken do
        render json: { error: 'Empty token' }, status: :bad_request
      end

      def not_found
        render json: { error: 'not found' }, status: :not_found
      end

      protected

      def token!
        @token = begin
          token = request.headers['Device-Token']

          raise Error::EmptyToken unless token

          token
        end
      end
    end
  end
end
