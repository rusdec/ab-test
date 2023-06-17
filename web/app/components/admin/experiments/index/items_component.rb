# frozen_string_literal: true

module Admin
  module Experiments
    module Index
      class ItemsComponent < ViewComponent::Base
        # @param [Sequel::Postgres::Dataset] items Experiment
        # @param [Integer] items_total_count
        def initialize(items:, items_total_count:)
          @items = items
          @items_total_count = items_total_count
        end

        def prepared_items
          @items.map do |experiment|
            distributed_options = distributed_options_hash[experiment.id]
            count_total = distributed_options.values.sum

            {
              id: experiment.id,
              title: experiment.title,
              key: experiment.key,
              devices_total_count: count_total,
              created_at: experiment.created_at,
              options: experiment.options.keys,
              result: experiment.options.keys.each_with_object({}) do |option, accum|
                percent_expected = experiment.options[option].round(1)
                count_real = distributed_options[option]

                if count_total == 0
                  percent_real = 0
                  percent_diff = 0
                else
                  percent_real = ((count_real.to_d / count_total) * 100).round(1)
                  percent_diff = (percent_real - percent_expected).round(1)
                end

                accum[option] = { count_real:, percent_expected:, percent_real:, percent_diff: }
              end
            }
          end
        end

        private

        def distributed_options_hash
          @distributed_options_hash ||= DistributedOptionsGroupAndCountQuery.new(@items)
            .call
            .each_with_object(Hash.new{ |h, k| h[k] = Hash.new(0) }) do |item, obj|
              obj[item.experiment_id][item[:value]] = item[:count]
            end
        end
      end
    end
  end
end
