FactoryBot.define do
  factory :experiment do
    to_create { _1.save }

    sequence(:title) { |n| "Experiment ##{n}" }
    sequence(:key) { |n| "any-key-#{n}" }
    distribution_type { :percentage }
    options do
      {
        cyan: 75,
        blue: 10,
        red: 10,
        white: 5
      }
    end
    #probability_line { self.set_probability_line }

    trait :uniform do
      distribution_type { :uniform }
      options do
        {
          cyan: 33.3,
          blue: 33.3,
          red:  33.3
        }
      end
    end
  end
end
