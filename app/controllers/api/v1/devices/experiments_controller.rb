module Api
  module V1
    module Devices
      class ExperimentsController < Api::V1::BaseController
        def index
          context = AddDeviceToExperiments.call(token: token!)

          json = context.device_token
            .device_experiment_values
            .joins(:experiment)
            .pluck(:key, :value)
            .to_h

          render json: json, status: :ok
        end
      end
    end
  end
end
