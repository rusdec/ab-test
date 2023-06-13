module Api
  module V1
    module Devices
      class ExperimentsController < Api::V1::BaseController
        def index
          context = AddDeviceToExperiments.call(token: token!)

          json = DB[:distributed_options]
            .join(:experiments, id: :experiment_id)
            .where(device_token_id: context.device_token.id)
            .pluck(:key, :value).to_h

          render json:, status: :ok
        end
      end
    end
  end
end
