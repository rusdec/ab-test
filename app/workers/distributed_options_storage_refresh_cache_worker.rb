# frozen_string_literal: true

class DistributedOptionsStorageRefreshCacheWorker
  include Sidekiq::Job

  sidekiq_options queue: 'distributed_options_storage_refresh_cache', retry: false

  def perform
    DistributedOptionsStorage.instance.refresh_cache
  end
end
