FactoryBot.define do
  factory :device_experiment_value do
    association :experiment
    association :device_token
    value { experiment.options.values.sample }
  end
end
