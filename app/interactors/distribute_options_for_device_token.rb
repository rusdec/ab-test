class DistributeOptionsForDeviceToken
  include Interactor

  BATCH_SIZE = 2000

  def call
    return if context.chosen_values.empty?

    context.chosen_values.each_slice(BATCH_SIZE) do |chosen_values|
      ::DistributedOption.multi_insert(chosen_values)
    end

    return unless context.use_data_cache

    ::DistributedOptionsStorage.instance.refresh_cache_async
  end
end
