require 'rails_helper'

RSpec.describe AddDeviceToExperiments do
  it 'organizes right interactors by right order' do
    expect(described_class.organized).to eq([
      RegisterDeviceToken,
      ChooseValuesFromExperiments,
      CreateValuesForDevice
    ])
  end
end
