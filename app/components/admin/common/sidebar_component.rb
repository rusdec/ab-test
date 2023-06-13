# frozen_string_literal: true

module Admin
  module Common
    class SidebarComponent < ViewComponent::Base
      def link(text, path)
        link_to text, path, class: current_page?(path) ? 'active' : ''
      end
    end
  end
end
