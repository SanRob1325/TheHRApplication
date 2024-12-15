require 'rails_helper'

RSpec.describe Attendance,type: :model do
  let(:department) {Department.create(name:"Marketing")}
  let(:employee) {Employee.create(name: "Jack Jones", email: "jackjones@example.com", department: department)}

  it "is valid with an employee,date and status" do
    attendance = Attendance.new(employee: employee, date: Date.today,status: "Present")
    expect(attendance).to be_valid
  end

  it "is invalid without a date" do
    attendance = Attendance.new(employee: employee, status: "Present")
    expect(attendance).not_to be_valid
    expect(attendance.errors[:date]).to include("can't be blank")
  end

  it "is invalid without a status" do
    attendance = Attendance.new(employee: employee, date: Date.today)
    expect(attendance).not_to be_valid
  end

  it "is invalid without an employee" do
    attendance = Attendance.new(date: Date.today, status: "Present")
    expect(attendance).not_to be_valid
    expect(attendance.errors[:employee]).to include("must exist")
  end

end