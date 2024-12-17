FactoryBot.define do
  factory :employee do
    name { "Jack Jones" }
    email { "jackjones@gmail.com" }
    association :department
  end
end
