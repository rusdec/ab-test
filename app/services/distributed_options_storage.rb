# TODO: переименовать в RoundRobinDistributor... ???
class DistributedOptionsStorage
  include ::Singleton

  class Storage
    KEY = 'distributed_options_storage'.freeze
    REFRESH_TIMEOUT_KEY = 'distributed_options_storage_async_refresh_timeout'.freeze
    REFRESH_TIMEOUT_SEC = 2

    def set(data)
      RedisConnection.set(KEY, data.to_json)
    end

    def fetch
      data = RedisConnection.get(KEY)

      data ? JSON.parse(data) : nil
    end

    def delete
      RedisConnection.del(KEY)
    end

    def async_refresh_timeout?
      !RedisConnection.get(REFRESH_TIMEOUT_KEY).nil?
    end

    def async_refresh_timeout!
      RedisConnection.set(REFRESH_TIMEOUT_KEY, true, ex: REFRESH_TIMEOUT_SEC)
    end
  end

  def initialize(storage = Storage.new)
    @storage = storage
  end

  # @return [Hash]
  #
  #   @example
  #     {
  #       "1" => {
  #         "#fffff" => 30,
  #         "#00000" =< 14
  #        }
  #     }
  def fetch
    ::DistributedOptionsGroupAndCountQuery.new(Experiment.uniform)
      .call.each_with_object({}) do |item, object|
        object[item.experiment_id.to_s] ||= {}
        object[item.experiment_id.to_s][item[:value]] = item[:count]
      end
  end

  def fetch_cache
    data = @storage.fetch

    return data if data

    refresh_cache

    @storage.fetch
  end

  def refresh_cache_async
    return if @storage.async_refresh_timeout?

    @storage.async_refresh_timeout!

    ::DistributedOptionsStorageRefreshCacheWorker.perform_async
  end

  def refresh_cache
    @storage.set(fetch)
  end

  def clear_cache!
    @storage.del
  end
end
