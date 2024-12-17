FactoryBot.define do
  factory :performance_review do
    association :employee
    reviewer { "Manager" }
    rating { Faker::Number.between(from: 1, to: 5) }
    feedback { Faker::Lorem.sentence(word_count: 10) }
  end
end
