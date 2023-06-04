class ExperimentValueProbabilitiesQuery
  # @param [Experiment::ActiveRecord_Relation]
  def initialize(experiments)
    @experiments = experiments
  end

  def call
    DeviceExperimentValue
      .select(:experiment_id, :value, 'COUNT (*) count')
      .where(experiment_id: @experiments.select(:id))
      .group(:experiment_id, :value)
  end
end
