class ChooseValuesFromExperiments
  include Interactor

  RANDOMIZER = Random.new(100)

  def call
    experiments = ::FindAvailableExperimentsQuery.new(context.device_token).call.pluck(:id, :options)

    context.chosen_values = experiments.map do |(id, options)|
      { experiment_id: id, value: choose_value(options) }
    end
  end

  private

  ##
  # Преобразует последовательность вероятностей в линейную.
  # ГСЧ с равномерным распределением генерирует число в заданном диапазоне.
  # Производится поиск индекс первого линейного значение, меньше чем сгенерированное число.
  # Преобразует найденое значение в значение эксперимента.
  #
  # @param [Hash] experiment_options Experiment#options
  #
  # @return [String] any key of Experiment#options
  def choose_value(experiment_options)
    probabilities = prepare_probabilities(experiment_options.values)

    r = RANDOMIZER.rand(probabilities.max)

    probability_index = probabilities.find_index { r < _1 }

    experiment_options.keys[probability_index]
  end

  def prepare_probabilities(probabilities)
    probabilities.each_index do |index|
      probabilities[index] += probabilities[index - 1] if index > 0
    end
  end
end
