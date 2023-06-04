class CreateValuesForDevice
  include Interactor

  def call
    return if context.chosen_values&.empty?

    prepared_values = context.chosen_values.map do |chosen_value|
      {
        device_token_id: context.device_token.id,
        experiment_id: chosen_value[:experiment_id],
        value: chosen_value[:value]
      }
    end

    DeviceExperimentValue.insert_all(prepared_values)
  end
end
