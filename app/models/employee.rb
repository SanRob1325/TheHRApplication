class Employee < ApplicationRecord
  belongs_to :department, optional: true
  has_many :attendances, dependent: :destroy
  has_many :performance_reviews, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[^@]+@[^@]+\z/ }
  validates :department_id, presence: true
  # validations for the populated fields and the associations between  tables in the database
  #  added email regex from : https://stackoverflow.com/questions/41348459/regex-in-react-email-validation
end
