FactoryBot.define do
  factory :leave_request do
    association :employee
    leave_type {"Casual"}
    start_date {Date.today}
    end_date {Date.today +3}
    reason {"Personal reason"}
    status{"Pending"}
  end
end