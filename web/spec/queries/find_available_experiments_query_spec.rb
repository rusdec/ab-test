require 'rails_helper'

RSpec.describe FindAvailableExperimentsQuery do
  describe '#call' do
    it 'does not find experiments created after the device token was created' do
      experiments_created_before = create_list(:experiment, rand(2..5))
      device_token = create(:device_token)
      create_list(:experiment, rand(2..5))

      relation = described_class.new(device_token).call.to_a

      expect(relation).to eq(experiments_created_before)
    end

    it 'does not find experiments for which values were already created' do
      experiments = create_list(:experiment, rand(2..5))
      device_token = create(:device_token)

      experiment_with_created_value = experiments.sample

      create(:distributed_option, device_token: device_token,
             experiment: experiment_with_created_value)

      relation = described_class.new(device_token).call.to_a

      expected_experiments = experiments.reject { _1 == experiment_with_created_value }

      expect(relation).to eq(expected_experiments)
    end

    it 'ignores values for other device tokens' do
      experiments = create_list(:experiment, rand(2..5))
      device_token = create(:device_token)
      other_device_token = create(:device_token)

      create(:distributed_option, device_token: other_device_token,
             experiment: experiments.sample)

      relation = described_class.new(device_token).call.to_a

      expect(relation).to eq(experiments)
    end
  end
end
