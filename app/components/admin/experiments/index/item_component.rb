# frozen_string_literal: true

module Admin
  module Experiments
    module Index
      class ItemComponent < ViewComponent::Base
        class << self
          def result_options(*options)
            options.each do |result_option|
              define_method result_option do |key|
                result[key][result_option]
              end
            end
          end
        end

        result_options :percent_expected,
                       :percent_real,
                       :percent_diff,
                       :count_expected,
                       :count_real,
                       :count_diff

        def initialize(item:)
          @item = item
        end

        def result
          @item[:result]
        end

        def options
          @item[:options]
        end

        def created_at
          @item[:created_at].strftime('%d.%m.%Y')
        end

        def signed_format(value)
          value.positive? ? "+#{value}" : value
        end

        def percent_format(value)
         "#{value}%" 
        end
      end
    end
  end
end
