class ValueDistributor
  UnknownDistributionTypeError = Class.new(StandardError)

  class UniformStrategy
    include Singleton

    # @return [String] any key of Experiment#options
    def next_value(experiment)
      value, = counters_cache[experiment.id].min { |a, b| a[1] <=> b[1] }
      counters_cache[experiment.id][value] += 1

      value
    end

    def refresh_cache
      @counters_cache = fetch_counters

      true
    end

    private

    def counters_cache
      @counters_cache ||= fetch_counters
    end

    def fetch_counters
      ::DistributedOptionsGroupAndCountQuery.new(Experiment.uniform).call
        .each_with_object({}) { |option, accum| add_distributed_counts(option, accum) }
        .tap { add_undistributed_counts(_1) }
    end

    def add_distributed_counts(option, accum)
      accum[option[:experiment_id]] ||= {}
      accum[option[:experiment_id]][option[:value]] = option[:count]
    end

    def add_undistributed_counts(accum)
      Experiment.uniform.pluck(:id, :options).each do |(id, options)|
        options.each_key do |key|
          accum[id] ||= {}
          accum[id][key] ||= 0
        end
      end
    end
  end

  class PercentageStrategy
    include Singleton

    RANDOMIZER = Random.new(100)

    # @return [String] any key of Experiment#options
    def next_value(experiment)
      r = RANDOMIZER.rand(experiment.probability_line.max)

      index = experiment.probability_line.find_index { r < _1 }

      experiment.options.keys[index]
    end
  end

  class << self
    def next_value(experiment)
      return UniformStrategy.instance.next_value(experiment) if experiment.uniform?
      return PercentageStrategy.instance.next_value(experiment) if experiment.percentage?

      raise UnknownDistributionTypeError, "Unknown experiment distribution type: '#{experiment.distribution_type}'"
    end

    def refresh_uniform_cache
      UniformStrategy.instance.refresh_cache
    end
  end
end
