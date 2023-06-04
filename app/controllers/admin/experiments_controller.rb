module Admin
  class ExperimentsController < ActionController::Base
    include Pagy::Backend

    layout "admin"

    def index
      pagination, experiments = pagy(Experiment.all, items: 10)
      device_experiment_values = ExperimentValueProbabilitiesQuery.new(experiments).call

      render Admin::Experiments::IndexComponent.new(
        title: 'Эксперименты',
        experiments: experiments,
        pagination: pagination,
        device_experiment_values: device_experiment_values
      )
    end
  end
end
