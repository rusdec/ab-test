require 'rails_helper'

RSpec.describe DeviceExperimentValue, type: :model do
  it { should belong_to(:experiment) }
  it { should belong_to(:device_token) }

  describe 'validations' do
    it { should validate_length_of(:value).is_at_most(1000).allow_blank }
  end
end
