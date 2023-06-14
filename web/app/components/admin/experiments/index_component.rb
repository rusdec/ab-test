# frozen_string_literal: true

module Admin
  module Experiments
    class IndexComponent < ViewComponent::Base
      # @param [String] title
      # @param [Sequel::Posgres::Dataset] items Experiment
      # @param [Pagy] pagination
      def initialize(title:, items:, pagination:)
        @title = title
        @items = items
        @pagination = pagination
      end
    end
  end
end
