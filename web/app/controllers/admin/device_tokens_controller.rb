module Admin
  class DeviceTokensController < BaseController
    include Pagy::Backend

    def index
      pagination, items = pagy(
        DeviceToken.dataset.order(Sequel.desc(:created_at)),
        items: 11,
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
