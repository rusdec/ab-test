FactoryBot.define do
  factory :device_token do
    sequence(:token) do |n|
      "any-uniq-token-#{n}"
    end

    trait :invalid do
      token { '' }
    end
  end
end
