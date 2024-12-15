class Attendance < ApplicationRecord
  belongs_to :employee

  validates :date, presence: true
  validates :status, presence: true, inclusion: { in: %w[Present Absent],message: "%{value} is not a valid status" }
end
