require 'rails_helper'

RSpec.describe DeviceToken, type: :model do
  it { should have_many(:device_experiment_values).dependent(:destroy) }
  it { should have_many(:experiments).through(:device_experiment_values) }

  describe 'validations' do
    describe '#token' do
      subject { build(:device_token) }

      it { should validate_presence_of(:token) }
      it { should validate_uniqueness_of(:token) }
    end
  end
end
