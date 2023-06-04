require 'rails_helper'

RSpec.describe ChooseValuesFromExperiments do
  describe '.call' do
    it 'chooses values from available experiments' do
      experiments = [
        create(:experiment, options: { green: 40, blue: 60 }),
        create(:experiment, options: { right: 10, left: 80, center: 10 }),
        create(:experiment, options: { small: 55, big:  45 })
      ]

      device_token = create(:device_token)

      allow(ChooseValuesFromExperiments::RANDOMIZER).to receive(:rand).and_return(
        39, # green
        99, # center
        56, # big
      )

      query = instance_double('FindAvailableExperimentsQuery')
      allow(query).to receive(:call).and_return(experiments)
      allow(FindAvailableExperimentsQuery).to receive(:new)
        .with(device_token).and_return(query)

      context = described_class.call(device_token: device_token)

      expect(context.chosen_values).to eq([
        { experiment_id: experiments[0].id, value: 'green' },
        { experiment_id: experiments[1].id, value: 'center' },
        { experiment_id: experiments[2].id, value: 'big' },
      ])
    end
  end
end
