require 'rails_helper'
# Test library
RSpec.describe LeaveRequest, type: :model do
  let(:department) { Department.create(name: "Marketing") }
  let(:employee) { Employee.create(name: "Jack Jones", email: "jackjones@gmail.com", department: department) }

  describe 'Validations' do
    it "is valid with an employee,leave type,start date,end date, and reason" do
      leave_request = LeaveRequest.new(employee: employee, leave_type: "Sick", start_date: Date.today, end_date: Date.today + 5, reason: "Medical Leave", status: "Pending")
      expect(leave_request).to be_valid
    end
    it "is invalid without an employee" do
      leave_request = LeaveRequest.new(leave_type: "Casual", start_date: Date.today, end_date: Date.today + 2, reason: "Vacation")
      expect(leave_request).not_to be_valid
      expect(leave_request.errors[:employee]).to include("must exist")
    end

    it "is invalid without a leave type" do
      leave_request = LeaveRequest.new(employee: employee, start_date: Date.today, end_date: Date.today + 3, reason: "Vacation")
      expect(leave_request).not_to be_valid
      expect(leave_request.errors[:leave_type]).to include("can't be blank")
    end

    it "is invalid without a start_date" do
      leave_request = LeaveRequest.new(employee: employee, leave_type: "Unpaid", end_date: Date.today + 3, reason: "Family Emergency")
      expect(leave_request).not_to be_valid
      expect(leave_request.errors[:start_date]).to include("can't be blank")
    end

    it "is invalid if start_date is after end_date" do
      leave_request = LeaveRequest.new(employee: employee, leave_type: "Casual", start_date: Date.today+ 3, end_date: Date.today, reason: "Personal time off")
      expect(leave_request).not_to be_valid
      expect(leave_request.errors[:end_date]).to include("End Date must be after Start Date")
    end
  end
end
