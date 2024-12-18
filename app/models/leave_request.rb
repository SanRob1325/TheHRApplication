class LeaveRequest < ApplicationRecord
  belongs_to :employee

  validates :leave_type, presence: true, inclusion: { in: %w[Casual Sick Unpaid Leave] }
  validates :leave_type, :start_date, :end_date, :status, presence: true
  validate :end_date_after_start_date

  private

  # A validation added to ensure the end date is not after the start date
  def end_date_after_start_date
    # Returns if the end date and start date are blank
    return if end_date.blank? || start_date.blank?
    # compares the end and start date to validate the order
    if end_date < start_date
      # error displays if end date is earlier than start date
      errors.add(:end_date, "End Date must be after Start Date")
    end
  end
end
