require 'rails_helper'

RSpec.describe DistributeOptionsForDeviceToken do
  describe '.call' do
    let(:device_token) { create(:device_token) }
    let!(:experiments) { create_list(:experiment, 3) }
    let(:chosen_values) do
      [
        { device_token_id: device_token.id, experiment_id: experiments[0].id, value: 'green' },
        { device_token_id: device_token.id, experiment_id: experiments[1].id, value: 'left' },
        { device_token_id: device_token.id, experiment_id: experiments[2].id, value: 'small' }
      ]
    end

    let(:context) do
      described_class.call(device_token: device_token, chosen_values: chosen_values)
    end

    let(:created_distributed_options) do
      DistributedOption.order(:experiment_id).last(experiments.count)
    end

    it 'creates device experiment values from available experiments' do
      expect { context }.to change(DistributedOption, :count).by(experiments.count)
    end

    it 'relates device experiment values with device token' do
      context

      device_token_ids = created_distributed_options.map(&:device_token_id)

      expect(device_token_ids).to all(eq(device_token.id))
    end

    it 'relates device experiment values with experiments' do
      context

      experiment_ids = created_distributed_options.map(&:experiment_id).sort
      expected_ids = experiments.map(&:id).sort

      expect(experiment_ids).to eq(expected_ids)
    end

    it 'creates device experiment values with right value' do
      context

      values = created_distributed_options.map(&:value).sort
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
        expect { context }.to_not change(DistributedOption, :count)
      end

      it 'should be success' do
        expect(context).to be_success
      end
    end
  end
end
