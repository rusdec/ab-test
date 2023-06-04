require 'rails_helper'

RSpec.describe CreateValuesForDevice do
  describe '.call' do
    let(:device_token) { create(:device_token) }
    let!(:experiments) { create_list(:experiment, 3) }
    let(:chosen_values) do
      [
        { experiment_id: experiments[0].id, value: 'green' },
        { experiment_id: experiments[1].id, value: 'left' },
        { experiment_id: experiments[2].id, value: 'small' }
      ]
    end

    let(:context) do
      described_class.call(device_token: device_token, chosen_values: chosen_values)
    end

    let(:created_device_experiment_values) do
      DeviceExperimentValue.last(experiments.count)
    end

    it 'creates device experiment values from available experiments' do
      expect { context }.to change(DeviceExperimentValue, :count).by(experiments.count)
    end

    it 'relates device experiment values with device token' do
      context

      device_token_ids = created_device_experiment_values.map(&:device_token_id)

      expect(device_token_ids).to all(eq(device_token.id))
    end

    it 'relates device experiment values with experiments' do
      context

      experiment_ids = created_device_experiment_values.map(&:experiment_id)

      expect(experiment_ids).to eq(experiments.map(&:id))
    end

    it 'creates device experiment values with right value' do
      context

      values = created_device_experiment_values.map(&:value).sort
      expected_values = chosen_values.map { _1[:value] }.sort

      expect(values).to eq(expected_values)
    end

    it 'should be success' do
      expect(context).to be_success
    end

    context 'when have not chosen values' do
      let(:context) do
        described_class.call(device_token: device_token, chosen_values: [])
      end

      it 'does not creates device experiment values' do
        expect { context }.to_not change(DeviceExperimentValue, :count)
      end

      it 'should be success' do
        expect(context).to be_success
      end
    end
  end
end
