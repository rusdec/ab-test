module Api
  module V1
    module Devices
      class ExperimentsController < Api::V1::BaseController
        def index
          device_token = DeviceToken.find(token: token!)

          unless device_token
            context = AddDeviceToExperiments.call(token: token!, use_storage_cache: true)
            device_token = context.device_token
          end

          json = DB[:distributed_options]
            .join(:experiments, id: :experiment_id)
            .where(device_token_id: device_token.id)
            .pluck(:key, :value).to_h

          render json:, status: :ok
        end
      end
    end
  end
end
