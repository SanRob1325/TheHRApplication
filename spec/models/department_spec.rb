require 'rails_helper'

RSpec.describe Department, type: :model do
  it "is valid with a name" do
    department = Department.new(name: "Engineering")
    expect(department).to be_valid
  end

  it "is not valid without a name" do
    department = Department.new
    expect(department).not_to be_valid
  end

  it 'is valid without a description' do
    department = Department.new(name: "Engineering", description: nil)
    expect(department).to be_valid
  end
end

describe 'Associations' do
  it 'can have many employees' do
    department = Department.create!(name: "Engineering", description: "Handles engineering tasks")
    employee1 = Employee.create(name: 'Alice', email: 'alice@example.com', department: department)
    employee2 = Employee.create(name: 'Bob', email: 'bob@example.com', department: department)

    department.reload
    expect(department.employees).to include(employee1, employee2)
  end
end
