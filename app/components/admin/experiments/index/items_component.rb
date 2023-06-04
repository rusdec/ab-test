# frozen_string_literal: true

module Admin
  module Experiments
    module Index
      class ItemsComponent < ViewComponent::Base
        # @param [Experimnet#ActiveRecord_Relation] experiments
        # @param [Integer] experimnets_total_count 
        # @param [DeviceExperimentValue::ActiveRecord_Relation] device_experiment_values Grouped by experiment_id and value
        #   @option [Ineger]  device_experiment_values.experiment_id
        #   @option [String]  device_experiment_values.value
        #   @option [Integer] device_experiment_values.count 
        def initialize(experiments:, experiments_total_count:, device_experiment_values:)
          @experiments = experiments
          @experiments_total_count = experiments_total_count
          @device_experiment_values = device_experiment_values
        end

        def prepared_items
          probabilities = value_probabilities_hash

          @experiments.map do |exp|
            {
              id: exp.id,
              title: exp.title,
              key: exp.key,
              devices_total_count: probabilities[exp.id]&.values&.sum(0) || 0,
              created_at: exp.created_at,
              options: exp.options.keys,
              result: exp.options.keys.each_with_object({}) do |option, obj|

                probability = probabilities[exp.id]
                probability = {} unless probability
                percent_expected = exp.options[option]
                count_total = probability.values.sum(0)
                count_real = probability[option] || 0
                if count_total == 0
                  count_expected = 0
                  percent_real = 0
                else
                  count_expected = ((percent_expected.to_f/100) * count_total).round(0)
                  percent_real =  ((count_real.to_f/count_total) * 100).round(0)
                end

                obj[option] = {
                  count_expected: count_expected,
                  count_real: count_real,
                  count_diff: count_real == 0 ? 0 : (count_real - count_expected).round(0),
                  percent_expected: percent_expected,
                  percent_real: percent_real,
                  percent_diff: percent_real == 0 ? 0 : (percent_real - percent_expected).round(0)
                }
              end
            }
          end
        end

        private

        def value_probabilities_hash
          @device_experiment_values.each_with_object({}) do |item, obj|
            obj[item.experiment_id] ||= {}     
            obj[item.experiment_id][item.value] = item.count
          end
        end
      end
    end
  end
end
