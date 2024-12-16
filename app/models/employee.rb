class Employee < ApplicationRecord
  belongs_to :department, optional: true
  has_many :attendances, dependent: :destroy
  has_many :performance_reviews, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[^@]+@[^@]+\z/ }
  validates :department_id, presence: true
end
