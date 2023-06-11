require 'rails_helper'

RSpec.describe DeviceToken, type: :model do
  it { is_expected.to have_one_to_many(:distributed_options) }
  it { is_expected.to have_many_to_many(:experiments) }

  describe 'validations' do
    describe '#token' do
      it { is_expected.to validate_unique :token }
      it { is_expected.to validate_presence :token }
      it { is_expected.to validate_min_length(1, :token) }
      it { is_expected.to validate_max_length(250, :token) }
    end
  end
end
