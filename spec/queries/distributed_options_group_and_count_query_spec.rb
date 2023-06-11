require 'rails_helper'

RSpec.describe DistributedOptionsGroupAndCountQuery do
  describe '#call' do
    it 'returns probabilities of value for given experiments' do
      experiments = create_list(:experiment, 2)
      other_experiments = create_list(:experiment, 2)

      create_list(:distributed_option, 3, experiment: other_experiments[1], value: 'right')

      create_list(:distributed_option, 3, experiment: experiments[0], value: 'x')
      create_list(:distributed_option, 5, experiment: experiments[0], value: 'y')

      create_list(:distributed_option, 2, experiment: experiments[1], value: 'small')
      create_list(:distributed_option, 7, experiment: experiments[1], value: 'big')

      create_list(:distributed_option, 2, experiment: other_experiments[0], value: 'left')

      expected_result = [
        { experiment_id: experiments[0].id, value: "x", count: 3 },
        { experiment_id: experiments[0].id, value: "y", count: 5 },

        { experiment_id: experiments[1].id, value: "big", count: 7 },
        { experiment_id: experiments[1].id, value: "small", count: 2 },
      ]

      experiments_relation = Experiment.where(id: experiments.map(&:id))

      result = described_class.new(experiments_relation).call.to_a.map!(&:values)

      expect(result.sort { _1[:value] <=> _2[:value] })
        .to eq(expected_result.sort { _1[:value] <=> _2[:value] })
    end
  end
end
