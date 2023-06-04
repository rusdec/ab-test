class FindAvailableExperimentsQuery
  # @param [DeviceToken] device_token
  def initialize(device_token)
    @device_token = device_token
  end

  def call
    Experiment
      .where('experiments.created_at <= ?', @device_token.created_at)
      .where.not(id: @device_token.device_experiment_values.select(:experiment_id))
  end
end
