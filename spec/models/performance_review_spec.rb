require 'rails_helper'

RSpec.describe PerformanceReview, type: :model do
  let(:department) {Department.create(name:"HR")}
  let(:employee) {Employee.create(name: "Alice",email: "alice@example.com", department: department)}

  describe "Validations" do
    it "is valid with an employee,review,rating, and feedback" do
      review = PerformanceReview.new(employee: employee, reviewer: "Manager 1", rating: 5, feedback: "Excellent work")
      expect(review).to be_valid
    end

    it "is invalid without a reviewer" do
      review = PerformanceReview.new(employee: employee, rating:4, feedback: "Good work")
      expect(review).not_to be_valid
      expect(review.errors[:reviewer]).to include("can't be blank")
    end

    it "is invalid without a rating" do
      review = PerformanceReview.new(employee: employee, reviewer: "Manager 1", feedback: "Good Work")
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("can't be blank")
    end

    it "is invalid if the rating is not between 1 and 5" do
      review = PerformanceReview.new(employee:employee, reviewer: "Manager 1", rating: 6, feedback: "Good Work")
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("must be between 1 and 5")
    end

    it "is invalid without feedback" do
      review = PerformanceReview.new(employee: employee, reviewer: "Manager 1", rating: 5)
      expect(review).not_to be_valid
      expect(review.errors[:feedback]).to include("can't be blank")
    end

    it "is invalid without an employee" do
      review = PerformanceReview.new(reviewer: "Manager 1", rating: 5,feedback: "Good Work")
      expect(review).not_to be_valid
      expect(review.errors[:employee]).to include("must exist")
    end


  end
end
