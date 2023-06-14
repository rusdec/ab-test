# frozen_string_literal: true

require 'forwardable'

module Admin
  module Experiments
    module Index
      class PaginationComponent < ViewComponent::Base
        extend Forwardable

        def_delegators :@pagination, :prev, :page, :next, :last, :pages

        # @param [Pagy] pagination
        def initialize(pagination:)
          @pagination = pagination
        end

        def link(page_num)
          link_to(page_num, admin_experiments_path(page: page_num))
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
end
