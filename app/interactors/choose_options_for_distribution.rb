class ChooseOptionsForDistribution
  include Interactor

  def call
    device_token = context.device_token

    context.chosen_values = ::FindAvailableExperimentsQuery.new(device_token).call
      .each_with_object([]) do |experiment, object|
        object << {
          device_token_id: device_token.id,
          experiment_id: experiment.id,
          value: ::ValueDistributor.next_value(experiment)
        }
      end
  end
end
