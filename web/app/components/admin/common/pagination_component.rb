# frozen_string_literal: true

require 'forwardable'

module Admin
  module Common
    class PaginationComponent < ViewComponent::Base
      extend Forwardable

      def_delegators :@pagination, :prev, :page, :next, :last, :pages

      # @param [Pagy] pagination
      def initialize(pagination:, resource:)
        @pagination = pagination
        @resource_path = "admin_#{resource}_path"
      end

      def link(page_num)
        link_to(page_num, public_send(@resource_path, { page: page_num }))
      end

      def show?
        pages > 1
      end

      def show_first?
        page > 2
      end

      def show_last?
        page < (last - 1)
      end
    end
  end
end
