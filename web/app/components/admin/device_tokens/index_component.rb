# frozen_string_literal: true

module Admin
  module DeviceTokens
    class IndexComponent < ViewComponent::Base
      # @param [String] title
      # @param [Sequel::Posgres::Dataset] device_items
      # @param [Pagy] pagination
      def initialize(title:, items:, pagination:)
        @title = title
        @items = items
        @pagination = pagination
      end
    end
  end
end
