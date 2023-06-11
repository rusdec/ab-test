require 'rails_helper'

RSpec.describe Experiment, type: :model do
  it { is_expected.to have_one_to_many(:distributed_options) }

  describe 'validations' do
    subject { build(:experiment) }

    describe '#title' do
      it { is_expected.to validate_presence(:title) }
      it { is_expected.to validate_min_length(1, :title) }
      it { is_expected.to validate_max_length(250, :title) }
    end

    describe '#key' do
      it { is_expected.to validate_presence(:key) }
      it { is_expected.to validate_min_length(1, :key) }
      it { is_expected.to validate_max_length(100, :key) }
    end

    describe '#options' do
      describe 'validates type' do
        context 'when hash' do
          it 'should be valid' do
            experiment = build(:experiment, options: { a: 100 })

            expect(experiment).to be_valid
          end
        end

        context 'when array' do
          it 'should be invalid' do
            experiment = build(:experiment, options: [:a, 100])

            expect(experiment).to_not be_valid
          end
        end

        context 'when nil' do
          it 'should be invalid' do
            experiment = build(:experiment, options: nil)

            expect(experiment).to_not be_valid
          end
        end

        context 'when other' do
          it 'should be invalid' do
            options = [100, '100', :a].sample

            experiment = build(:experiment, options: options)

            expect(experiment).to_not be_valid
          end
        end
      end

      describe 'validates length of values' do
        context 'when length of any value is 1' do
          it 'should be valid' do
            experiment = build(:experiment, options: { x: 100 })

            expect(experiment).to be_valid
          end
        end

        context 'when length of any value less than 100' do
          it 'should be valid' do
            value = ('a'..'z').to_a.sample * 99
            experiment = build(:experiment, options: { value => 100 })

            expect(experiment).to be_valid
          end
        end

        context 'when length of any value is 100' do
          it 'should be valid' do
            value = ('a'..'z').to_a.sample * 100
            experiment = build(:experiment, options: { value => 100 })

            expect(experiment).to be_valid
          end
        end

        context 'when length of any value more than 100' do
          it 'should be invalid' do
            value = ('a'..'z').to_a.sample * 101
            experiment = build(:experiment, options: { value => 100 })

            expect(experiment).to_not be_valid
          end
        end
      end

      describe 'validates sum of probabilities' do
        context 'when sum less than 99.9' do
          it 'should be invalid' do
            experiment = build(:experiment, options: { a: 90, b: 9.8 })

            expect(experiment).to_not be_valid
          end
        end

        context 'when sum equal 99.9' do
          it 'should be valid' do
            experiment = build(:experiment, options: { a: 90, b: 9.9 })

            expect(experiment).to be_valid
          end
        end

        context 'when sum equal 100' do
          it 'should be valid' do
            experiment = build(:experiment, options: { a: 90, b: 10 })

            expect(experiment).to be_valid
          end
        end

        context 'when sum more than 100' do
          it 'should be invalid' do
            experiment = build(:experiment, options: { a: 90, b: 10.1 })

            expect(experiment).to_not be_valid
          end
        end
      end
    end
  end

  describe '#set_probabilities' do
    it 'sets probabilitiesi before save' do
      experiment = build(:experiment, options: { a: 75, b: 5, c: 10, d: 3, e: 7 })

      experiment.save

      expect(experiment.probability_line).to eq([75, 80, 90, 93, 100])
    end
  end

  describe '#set_distribution' do
    context 'when difference between min and max probabilties is 0' do
      context 'and only one option' do
        it 'sets uniform distribution before save' do
          experiment = build(:experiment, options: { a: 33.3, b: 33.3, c: 33.3 })

          experiment.save

          expect(experiment).to be_uniform
        end
      end

      context 'and few options' do
        it 'sets percentage distribution before save' do
          experiment = build(:experiment, options: { a: 100 })

          experiment.save

          expect(experiment).to be_percentage
        end
      end
    end

    context 'when difference between min and max probabilties is 1' do
      it 'sets uniform distribution before save' do
        experiment = build(:experiment, options: { a: 34, b: 33, c: 33 })

        experiment.save

        expect(experiment).to be_uniform
      end
    end

    context 'when difference between min and max probabilties more than 1' do
      it 'sets percentage distribution before save' do
        experiment = build(:experiment, options: { a: 35, b: 33, c: 32 })

        experiment.save

        expect(experiment).to be_percentage
      end
    end
  end
end
