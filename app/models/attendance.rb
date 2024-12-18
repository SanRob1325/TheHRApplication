class Attendance < ApplicationRecord
  belongs_to :employee

  validates :date, presence: true
  validates :status, inclusion: { in: %w[Present Absent], message: "is not included in the list" }
  validates :employee_id, uniqueness: { scope: :date, message: "already has an attendance record for this date" }
  validate :date_cannot_be_in_the_future

  private

  # ensures noo future dates can be selected
  def date_cannot_be_in_the_future
    # Check if the date attribute is prent or not
    if date.present? && date > Date.today
      # Add a validation error if the date is greater than today's date
      errors.add(:date, "can't be in the future")
    end
  end
end
