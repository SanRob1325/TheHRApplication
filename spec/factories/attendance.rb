FactoryBot.define do
  factory :attendance do
    association :employee
    date { Date.today }
    status { "Present" }
  end
end
