require 'rails_helper'

RSpec.describe ChooseOptionsForDistribution do
  describe '.call' do
    context 'when experiment distribution type is percentage' do
      it 'chooses values from available experiments using value distributor' do
        experiments = [
          create(:experiment, :percentage, options: { green: 40, blue: 60 }),
          create(:experiment, :percentage, options: { right: 10, left: 80, center: 10 }),
          create(:experiment, :uniform, options: { small: 50, big: 50 })
        ]

        device_token = create(:device_token)

        allow(ValueDistributor).to receive(:next_value)
          .and_return('green', 'center', 'big')

        context = described_class.call(device_token: device_token)

        expect(context.chosen_values).to eq([
          { device_token_id: device_token.id, experiment_id: experiments[0].id, value: 'green' },
          { device_token_id: device_token.id, experiment_id: experiments[1].id, value: 'center' },
          { device_token_id: device_token.id, experiment_id: experiments[2].id, value: 'big' },
        ])
      end
    end
  end
end
