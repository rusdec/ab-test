require 'rails_helper'

RSpec.describe ExperimentValueProbabilitiesQuery do
  describe '#call' do
    it 'returns probabilities of value for given experiments' do
      experiments = create_list(:experiment, 3)
      other_experiments = create_list(:experiment, 2)

      create_list(:device_experiment_value, 3, experiment: other_experiments[1], value: 'right')

      create_list(:device_experiment_value, 3, experiment: experiments[0], value: 'x')
      create_list(:device_experiment_value, 5, experiment: experiments[0], value: 'y')

      create_list(:device_experiment_value, 2, experiment: experiments[1], value: 'small')
      create_list(:device_experiment_value, 7, experiment: experiments[1], value: 'big')

      create_list(:device_experiment_value, 2, experiment: other_experiments[0], value: 'left')

      expected_result = [
        { "id" => nil, "experiment_id" => experiments[0].id, "value" => "x", "count" => 3 },
        { "id" => nil, "experiment_id" => experiments[0].id, "value" => "y", "count" => 5 },

        { "id" => nil, "experiment_id" => experiments[1].id, "value" => "big", "count" => 7 },
        { "id" => nil, "experiment_id" => experiments[1].id, "value" => "small", "count" => 2 },
      ]

      experiments_relation = Experiment.where(id: experiments.map(&:id))

      result = described_class.new(experiments_relation).call.map(&:attributes)

      expect(result).to eq(expected_result)
    end
  end
end
