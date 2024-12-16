class LeaveRequest < ApplicationRecord
  belongs_to :employee

  validates :leave_type , presence: true, inclusion: { in: %w(Casual Sick Unpaid Leave) }
  validates :leave_type, :start_date, :end_date, :status, presence: true
  validate :end_date_after_start_date

  private
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "End Date must be after Start Date")
    end
  end
end
