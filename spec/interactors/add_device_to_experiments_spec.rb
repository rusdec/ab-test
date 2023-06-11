require 'rails_helper'

RSpec.describe AddDeviceToExperiments do
  it 'organizes right interactors by right order' do
    expect(described_class.organized).to eq([
      RegisterDeviceToken,
      ChooseOptionsForDistribution,
      DistributeOptionsForDeviceToken
    ])
  end
end
