require 'rails_helper'

RSpec.describe Employee,type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      department = Department.create(name: "HR", description: "Handles HR tasks")
    end
  end
  it "is valid with a name,email , and department" do
    department = Department.create(name: "Engineering")
    employee = Employee.new(name: "Jack Jones", email:"jackjones@example.com",department: department)
    expect(employee).to be_valid
  end

  it "is not valid without a name" do
    employee = Employee.new(email: "jackjones@example.com")
    expect(employee).not_to be_valid
  end

  it "is not valid without a email" do
    employee = Employee.new(name: "Jack Jones")
    expect(employee).not_to be_valid
  end

  it "belongs to a department" do
    department = Department.create(name: "Marketing")
    employee = Employee.create(name: "Jack Jones", email: "jackjones@example.com",department: department)
    expect(employee.department).to eq(department)
  end

  it "is not valid with and incorrect email format" do
    employee = Employee.new(name: "Jack Jones",email: "invalid-email")
    expect(employee).not_to be_valid
  end

end