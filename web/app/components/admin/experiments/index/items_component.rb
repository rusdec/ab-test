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
            experiment.values.slice(:id, :title, :key, :created_at).merge!(
              devices_total_count: devices_total_count(experiment),
              options: experiment.options.keys,
              statistics: experiment.options.keys.index_with { statistics(experiment, _1) }
            )
          end
        end

        private

        def devices_total_count(experiment)
          distributed_options[experiment.id].values.sum
        end

        def distributed_options
          @distributed_options ||= DistributedOptionsGroupAndCountQuery.new(@items).call
            .each_with_object(Hash.new { |h, k| h[k] = Hash.new(0) }) do |item, accum|
              accum[item.experiment_id][item[:value]] = item[:count]
            end
        end

        def statistics(experiment, option)
          count_total = devices_total_count(experiment)

          count_real = distributed_options[experiment.id][option]
          percent_expected = experiment.options[option].round(1)
          percent_real = count_total == 0 ? 0 : ((count_real.to_d / count_total) * 100).round(1)
          percent_diff = count_total == 0 ? 0 : (percent_real - percent_expected).round(1)

          { count_real:, percent_expected:, percent_real:, percent_diff: }
        end
      end
    end
  end
end
