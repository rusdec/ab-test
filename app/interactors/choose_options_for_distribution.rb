class ChooseOptionsForDistribution
  include Interactor

  RANDOMIZER = Random.new(100)

  def call
    device_token = context.device_token

    context.chosen_values = ::FindAvailableExperimentsQuery.new(device_token).call
      .each_with_object([]) do |experiment, object|
        object << {
          device_token_id: device_token.id,
          experiment_id: experiment.id,
          value: choose_option(experiment)
        }
      end
  end

  private

  def choose_option(experiment)
    experiment.uniform? ? uniform_distribution(experiment) : percentage_distribution(experiment)
  end

  # @return [String] any key of Experiment#options
  def uniform_distribution(experiment)
    item = probability_hash[experiment.id.to_s] || {}

    experiment.options.each_key { item[_1] ||= 0 } if item.size != experiment.options.size

    value, = item.to_a.shuffle!.min { |a, b| a[1] <=> b[1] }

    value
  end

  def probability_hash
    @probability_hash ||= begin
      storage = DistributedOptionsStorage.instance

      context.use_storage_cache ? storage.fetch_cache : storage.fetch
    end
  end

  # @return [String] any key of Experiment#options
  def percentage_distribution(experiment)
    probability_line = experiment.probability_line.map(&:to_d)
    r = RANDOMIZER.rand(probability_line.max)

    index = probability_line.find_index { r < _1 }

    experiment.options.keys[index]
  end
end
