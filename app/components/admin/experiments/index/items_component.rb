# frozen_string_literal: true

module Admin
  module Experiments
    module Index
      class ItemsComponent < ViewComponent::Base
        # @param [Sequel::Postgres::Dataset] experiments
        # @param [Integer] experimnets_total_count
        def initialize(experiments:, experiments_total_count:)
          @experiments = experiments
          @experiments_total_count = experiments_total_count
        end

        def prepared_items
          @experiments.map do |exp|
            exp_distributed_values = distributed_options_hash[exp.id] || {}
            count_total = exp_distributed_values.values.sum || 0

            {
              id: exp.id,
              title: exp.title,
              key: exp.key,
              devices_total_count: count_total,
              created_at: exp.created_at,
              options: exp.options.keys,
              result: exp.options.keys.each_with_object({}) do |option, obj|
                percent_expected = exp.options[option].to_d
                count_real = exp_distributed_values[option] || 0
                if count_total == 0
                  count_expected = 0
                  percent_real = 0
                else
                  count_expected = ((percent_expected.to_d / 100) * count_total).round(0)
                  percent_real = ((count_real.to_d / count_total) * 100).round(0)
                end

                obj[option] = {
                  count_expected:,
                  count_real:,
                  count_diff: count_real == 0 ? 0 : (count_real - count_expected).round(0),
                  percent_expected:,
                  percent_real:,
                  percent_diff: percent_real == 0 ? 0 : (percent_real - percent_expected).round(0)
                }
              end
            }
          end
        end

        private

        def distributed_options_hash
          @distributed_options_hash ||= DistributedOptionsGroupAndCountQuery.new(@experiments)
            .call.each_with_object({}) do |item, obj|
              obj[item.experiment_id] ||= {}
              obj[item.experiment_id][item[:value]] = item[:count]
            end
        end
      end
    end
  end
end
