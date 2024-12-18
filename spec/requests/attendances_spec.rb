require 'rails_helper'
#Test library
RSpec.describe 'Attendance Requests API', type: :request do
#Creates a department and employee for attendances that are being tested
  let!(:department) { create(:department) }
  let!(:employee) { create(:employee, department: department) }
# Creates multiple attendance records for the employee
  let!(:attendances) do
    (1..3).map { |n| create(:attendance, employee: employee, date: Date.today - n.days) }
  end
# Fetches the ID for multiple attendance records for the employee
  let!(:attendance_id) { attendances.first.id }

  describe 'GET /attendances' do
    it "returns all attendances" do
      get "/attendances"

      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(3)
    end
  end

  describe 'GET /attendances/:id' do
    it "returns a specific attendance" do
      get "/attendances/#{attendance_id}"

      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(attendance_id)
    end
  end

  describe 'POST /attendances' do
    let(:valid_attributes) { { attendance: { employee_id: employee.id, date: Date.today, status: "Present" } } }

    context 'when the request is valid' do
      it 'creates a attendance' do
        expect {
          post "/attendances", params: valid_attributes
        }.to change(Attendance, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json["status"]).to eq("Present")
      end
    end

    context 'when the request is invalid' do
      it 'does not create a attendance' do
        post "/attendances", params: { attendance: { employee_id: nil, date: nil, status: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Employee must exist", "Date can't be blank", "Status is not included in the list")
    end
    end
  end

  describe 'PUT /attendances/:id' do
    let(:valid_attributes) { { attendance: { status: "Absent" } } }

    context 'when the record exists' do
      it 'updates the attendance record' do
        put "/attendances/#{attendance_id}", params: valid_attributes

        expect(response).to have_http_status(:ok)
        expect(json["status"]).to eq("Absent")
      end
    end

    context 'when the record does not exist' do
      it "returns a not found error" do
        put "/attendances/999999", params: { attendance: { status: "Absent" } }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Attendance not found")
      end
    end
  end

  describe 'DELETE /attendances/:id' do
    it "deletes the attendance record" do
      expect {
        delete "/attendances/#{attendance_id}"
      }.to change(Attendance, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end

private

# Helps parse JSON responses Reference:https://ruby-doc.org/stdlib-3.0.1/libdoc/json/rdoc/JSON.html
def json
  JSON.parse(response.body)
end
