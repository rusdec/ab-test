module Admin
  class ExperimentsController < ApplicationController
    include Pagy::Backend

    layout 'admin'

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
