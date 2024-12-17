require 'rails_helper'

RSpec.describe Attendance,type: :model do
  let(:department) {Department.create(name:"Marketing")}
  let(:employee) {Employee.create(name: "Jack Jones", email: "jackjones@example.com", department: department)}

  describe "Valitdations" do
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

    it "is invalid with an incorrect status" do
      attendance = Attendance.new(employee: employee,date: Date.today, status: "Unknown")
      expect(attendance).not_to be_valid
      expect(attendance.errors[:status]).to include("is not included in the list")
    end

    it "is invalid with a future date" do
      attendance = Attendance.new(employee: employee, date: Date.tomorrow,status: "Present" )
      expect(attendance).not_to be_valid
      expect(attendance.errors[:date]).to include("can't be in the future")
    end

    it "is invalid if an attendance record already exists for the same employee and date" do
      Attendance.create!(employee: employee, date: Date.today, status: "Present")
      duplicate_attendance = Attendance.new(employee: employee, date: Date.today, status: "Absent")
      expect(duplicate_attendance).not_to be_valid
      expect(duplicate_attendance.errors[:employee_id]).to include("already has an attendance record for this date")
    end
  end

  describe "Associations" do
    it "belongs to an employee" do
      attendance = Attendance.create(employee: employee, date: Date.today, status: "Present")
      expect(attendance.employee).to eq(employee)
    end
  end
end


