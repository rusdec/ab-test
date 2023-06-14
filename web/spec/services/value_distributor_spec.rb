require 'rails_helper'

RSpec.describe ValueDistributor do
  describe '.next_value' do
    context 'when experiment is uniform' do
      it 'distribute values evently' do
        experiment = create(:experiment, :uniform, options: { x: 33.3, y: 33.3, z: 33.3 })

        counts = Hash.new(0);

        100.times do
          value = described_class.next_value(experiment)
          counts[value] += 1
        end

        min, max = counts.values.minmax

        expect(max - min).to eq(0).or eq(1)
      end

      it 'uses already destributed options counts' do
        experiment = create(:experiment, :uniform, options: { x: 33.3, y: 33.3, z: 33.3 })

        create(:distributed_option, experiment: experiment, value: 'x')
        create(:distributed_option, experiment: experiment, value: 'x')
        create(:distributed_option, experiment: experiment, value: 'x')
        create(:distributed_option, experiment: experiment, value: 'y')
        create(:distributed_option, experiment: experiment, value: 'y')

        described_class::UniformStrategy.instance.refresh_cache

        values = []
        3.times { values << described_class.next_value(experiment) }

        expect(values).to eq(['z', 'z', 'y']).or eq(['z', 'z', 'z'])
      end
    end

    context 'when experiment is percentage' do
      it 'distributes values by percentage' do
        experiment = create(:experiment, :percentage, options: { x: 10, y: 30, z: 60 })

        counts = Hash.new(0);

        100.times do
          value = described_class.next_value(experiment)
          counts[value] += 1
        end

        x, y, z = experiment.options.fetch_values('x', 'y', 'z')

        expect(counts).to satisfy do |c|
          x < y && y < z
        end
      end
    end

    context 'when experiment have other distribution type' do
      it 'raises error' do
        distribution_type = [:other, :unknown, :any].sample
        experiment = build(:experiment, distribution_type: distribution_type)

        expect { described_class.next_value(experiment) }
          .to raise_error(
            ValueDistributor::UnknownDistributionTypeError,
            "Unknown experiment distribution type: '#{distribution_type}'"
          )
      end
    end
  end

  describe '.refresh_uniform_cache' do
    it 'refreshes cache for uniform strategy' do
      expected_method = :refresh_cache

      uniform_strategy = described_class::UniformStrategy.instance
      allow(uniform_strategy).to receive(expected_method).and_call_original

      described_class.refresh_uniform_cache

      expect(uniform_strategy).to have_received(expected_method).once
    end
  end
end
