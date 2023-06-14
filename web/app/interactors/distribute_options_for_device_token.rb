class DistributeOptionsForDeviceToken
  include Interactor

  BATCH_SIZE = 2000

  def call
    context.chosen_values.each_slice(BATCH_SIZE) do |chosen_values|
      ::DistributedOption.multi_insert(chosen_values)
    end
  end
end
