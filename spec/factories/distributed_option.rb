FactoryBot.define do
  factory :distributed_option do
    to_create { _1.save }

    association :device_token
    association :experiment
    value { experiment.options.values.sample }
  end
end
