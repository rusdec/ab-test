module Api
  module V1
    class BaseController < ActionController::API
      include Helpers

      rescue_from Error::EmptyToken do |error|
        render json: { error: 'Empty token' }, status: :bad_request
      end

      protected

      def token!
        @token = begin

          token = if Rails.env.development?
                    request.headers['Device-Token'] || params[:token]
                  else
                    request.headers['Device-Token']
                  end

          raise Error::EmptyToken unless token

          token
        end
      end
    end
  end
end
