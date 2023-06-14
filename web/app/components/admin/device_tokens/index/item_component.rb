# frozen_string_literal: true

module Admin
  module DeviceTokens
    module Index
      class ItemComponent < ViewComponent::Base
        def initialize(item:)
          @item = item
        end

        def created_at
          @item[:created_at].strftime('%d.%m.%Y')
        end
      end
    end
  end
end
