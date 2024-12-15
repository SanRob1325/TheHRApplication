require 'rails_helper'

RSpec.describe Department,type: :model do
  it "is valid with a name" do
    department = Department.new(name: "Engineering")
    expect(department).to be_valid
  end

  it "is not valid without a name" do
    department = Department.new
    expect(department).not_to be_valid
  end
end