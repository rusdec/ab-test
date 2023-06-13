# frozen_string_literal: true

module Admin
  module DeviceTokens
    module Index
      class ItemsComponent < ViewComponent::Base
        # @param [Sequel::Postgres::Dataset] items DeviceToken
        # @param [Integer] items_total_count
        def initialize(items:, items_total_count:)
          @items = items
          @items_total_count = items_total_count
        end

        def prepared_items
          @items.map do |item|
            {
              id: item.id,
              token: item.token,
              created_at: item.created_at
            }
          end
        end
      end
    end
  end
end
