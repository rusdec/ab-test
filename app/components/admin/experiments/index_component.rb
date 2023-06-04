# frozen_string_literal: true

module Admin
  module Experiments
    class IndexComponent < ViewComponent::Base
      # @param [String] title
      # @param [Experiment::ActiveRecord_Relation] experiments
      # @param [Pagy] pagination
      # @param [DeviceExperimentValue::ActiveRecord_Relation] device_experiment_values Grouped by experiment_id and value
      #   @option [Ineger]  device_experiment_values.experiment_id
      #   @option [String]  device_experiment_values.value
      #   @option [Integer] device_experiment_values.count 
      def initialize(title:, experiments:, pagination:, device_experiment_values:)
        @title = title
        @experiments = experiments
        @pagination = pagination
        @device_experiment_values = device_experiment_values
      end
    end
  end
end
