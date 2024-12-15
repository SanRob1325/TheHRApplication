class Employee < ApplicationRecord
  belongs_to :department, optional: true
  has_many :attendances, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[^@]+@[^@]+\z/ }
end
