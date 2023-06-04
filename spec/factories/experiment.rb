FactoryBot.define do
  factory :experiment do
    sequence(:title) { |n| "Experiment ##{n}" }
    description { "" }
    sequence(:key) { |n| "any-key-#{n}" }
    options do
      {
        cyan: 10,
        blue: 20,
        green: 30,
        brown: 40,
      }
    end
  end
end
