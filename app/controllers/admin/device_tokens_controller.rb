module Admin
  class DeviceTokensController < ApplicationController
    include Pagy::Backend

    layout 'admin'

    def index
      pagination, items = pagy(
        DeviceToken.dataset.order(Sequel.desc(:created_at)),
        items: 9,
        count: DeviceToken.count
      )

      render Admin::DeviceTokens::IndexComponent.new(
        title: 'Токены устройств',
        items:,
        pagination:
      )
    end
  end
end
