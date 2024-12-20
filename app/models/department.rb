class Department < ApplicationRecord
  has_many :employees, dependent: :destroy

  validates :name, presence: true
  # validations for the populated fields and the associations between  tables in the database
end
