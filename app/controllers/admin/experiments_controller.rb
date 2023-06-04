module Admin
  class ExperimentsController < ApplicationController
    include Pagy::Backend

    layout 'admin'

    def index
      pagination, experiments = pagy(Experiment.all, items: 10)
      value_probabilities_query = ExperimentValueProbabilitiesQuery.new(experiments)

      render Admin::Experiments::IndexComponent.new(
        title: 'Эксперименты',
        experiments:,
        pagination:,
        value_probabilities_query:
      )
    end
  end
end
