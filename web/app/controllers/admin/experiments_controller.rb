module Admin
  class ExperimentsController < BaseController
    include Pagy::Backend

    def index
      pagination, items = pagy(
        Experiment.dataset.order(Sequel.desc(:created_at)),
        items: 9,
        count: Experiment.count
      )

      render Admin::Experiments::IndexComponent.new(
        title: 'Эксперименты',
        items:,
        pagination:
      )
    end
  end
end
