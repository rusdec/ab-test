# frozen_string_literal: true

module Admin
  module Experiments
    class IndexComponent < ViewComponent::Base
      # @param [String] title
      # @param [Experiment::ActiveRecord_Relation] experiments
      # @param [Pagy] pagination
      # @param [ExperimentValueProbabilitiesQuery] value_probabilities_query
      def initialize(title:, experiments:, pagination:, value_probabilities_query:)
        @title = title
        @experiments = experiments
        @pagination = pagination
        @value_probabilities_query = value_probabilities_query
      end
    end
  end
end
