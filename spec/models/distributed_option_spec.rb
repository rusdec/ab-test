require 'rails_helper'

RSpec.describe DistributedOption, type: :model do
  it { is_expected.to have_many_to_one(:experiment) }
  it { is_expected.to have_many_to_one(:device_token) }

  describe '#validate' do
    describe '#value' do
      it { is_expected.to validate_presence :value }
      it { is_expected.to validate_min_length(1, :value) }
      it { is_expected.to validate_max_length(100, :value) }
    end
  end
end
