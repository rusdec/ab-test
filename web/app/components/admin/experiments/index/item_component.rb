# frozen_string_literal: true

module Admin
  module Experiments
    module Index
      class ItemComponent < ViewComponent::Base
        class << self
          def statistics(*statistic_names)
            statistic_names.each do |statistic_name|
              define_method statistic_name do |experiment_option|
                @item[:statistics][experiment_option][statistic_name]
              end
            end
          end
        end

        statistics :percent_expected,
                   :percent_real,
                   :percent_diff,
                   :count_expected,
                   :count_real,
                   :count_diff

        def initialize(item:)
          @item = item
        end

        def options
          @item[:options]
        end

        def created_at
          @item[:created_at].strftime('%d.%m.%Y')
        end

        def signed_format(value)
          value > 0 ? "+#{value}" : value
        end

        def percent_format(value)
          "#{value}%"
        end
      end
    end
  end
end
