FactoryBot.define do
  factory :device_token do
    to_create { _1.save }

    sequence(:token) do |n|
      "any-uniq-token-#{n}"
    end

    trait :invalid do
      token { '' }
    end
  end
end
