module Api
  module V1
    class BaseController < ActionController::API
      rescue_from Error::EmptyToken do
        render json: { error: 'Empty token' }, status: :bad_request
      end

      protected

      def token!
        @token = begin
          token = params[:token] || request.headers['Device-Token']

          raise Error::EmptyToken unless token

          token
        end
      end
    end
  end
end
