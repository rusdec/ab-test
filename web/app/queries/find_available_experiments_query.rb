class FindAvailableExperimentsQuery
  # @param [DeviceToken] device_token
  def initialize(device_token)
    @device_token = device_token
  end

  def call
    token_created_at = @device_token.created_at
    id = @device_token.id

    Experiment
      .where { created_at <= token_created_at }
      .exclude(
        id: DistributedOption.select(:experiment_id).where(device_token_id: id)
      )
  end
end
