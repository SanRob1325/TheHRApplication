require 'rails_helper'

RSpec.describe "LeaveRequests", type: :request do
  let!(:department) { Department.create(name: "HR") }
  let!(:employee) {Employee.create(name: "Alice", email: "alice@example.com", department: department)}
  let!(:leave_requests) { create_list(:leave_request, 3, employee: employee) }

  let(:valid_attributes) do
    {
      leave_request: {
        employee_id: employee.id,
        leave_type: "Sick",
        start_date: Date.today,
        end_date: Date.today+ 2,
        reason: "Flu",
        status: "Pending"
      }
    }
  end

  let(:invalid_attributes) do
    {
    leave_request: {
      employee_id: nil,
      leave_type: nil,
      start_date: nil,
      end_date: nil,
      reason: nil,
      status: nil
    }
    }
  end

  describe "GET /leave_requests" do
    it "returns all leave_requests" do
      get "/leave_requests"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "POST /leave_requests" do
    context "when the request is valid" do
      it "creates a new leave_request" do
        expect {
          post "/leave_requests", params: valid_attributes
        }.to change(LeaveRequest, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end
  end

  describe "PUT /leave_requests/:id" do
    context "when the record exists" do
      let(:updated_attributes) do
        {
          leave_request: {
            leave_type: "Casual",
            start_date: Date.today,
            end_date: Date.today + 1,
            reason: "Vacation",
            status: "Pending"
          }
        }
      end

      it "updates the record" do
        put "/leave_requests/#{leave_requests.first.id}", params: updated_attributes
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["leave_type"]).to eq("Casual")
        expect(JSON.parse(response.body)["status"]).to eq("Pending")
      end
    end

    context "when the record does not exist" do
      it "responds with not found error" do
        put "/leave_requests/9999", params: valid_attributes
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("LeaveRequest not found")
      end
    end
  end

  describe "DELETE /leave_requests/:id" do
    it "deletes the leave request" do
      expect {
        delete "/leave_requests/#{leave_requests.first.id}"
      }.to change(LeaveRequest, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end



