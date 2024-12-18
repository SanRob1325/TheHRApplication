class PerformanceReview < ApplicationRecord
  belongs_to :employee

  validates :reviewer, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5, message: "must be between 1 and 5" } # ratings only valid from 1-5
  validates :feedback, presence: true
end
