require 'rails_helper'

RSpec.describe Experiment, type: :model do
  it { should have_many(:device_experiment_values).dependent(:destroy) }

  describe 'validations' do
    subject { build(:experiment) }

    describe '#title' do
      it { should validate_presence_of(:title) }
      it { should validate_length_of(:title).is_at_least(1).is_at_most(250) }
    end

    describe '#description' do
      it { should allow_values(nil, '').for(:description) }
      it { should validate_length_of(:description).is_at_most(1000) }
    end

    describe '#key' do
      it { should validate_presence_of(:key) }
      it { should validate_length_of(:key).is_at_least(1).is_at_most(250) }
    end

    describe '#options' do
      it { should allow_values(nil, '').for(:options) }
    end
  end
end
