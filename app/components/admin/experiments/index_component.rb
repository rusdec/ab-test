# frozen_string_literal: true

module Admin
  module Experiments
    class IndexComponent < ViewComponent::Base
      # @param [String] title
      # @param [Sequel::Posgres::Dataset] experiments
      # @param [Pagy] pagination
      def initialize(title:, experiments:, pagination:)
        @title = title
        @experiments = experiments
        @pagination = pagination
      end
    end
  end
end
