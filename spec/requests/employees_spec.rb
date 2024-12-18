require 'rails_helper'
#Test library
RSpec.describe 'Employees API', type: :request do
  let!(:department) { Department.create(name: "HR", description: "Handles HR management") }
  let!(:employee) { Employee.create(name: "Jack Jones", email: "jackjones@example.com", department: department) }

  describe "GET /employees" do
    it "returns a list of all employees and their associated departments" do
      get "/employees"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(1)
      expect(json_response.first["name"]).to eq("Jack Jones")
      expect(json_response.first["department"]["name"]).to eq("HR")
    end
  end

  describe "GET /employees/:id" do
    it "returns a specific employee with their department" do
      get "/employees/#{employee.id}"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq("Jack Jones")
      expect(json_response["department"]["name"]).to eq("HR")
    end

    it "returns a 404 if the employees is not found" do
      get '/employees/0'

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /employees" do
    let(:valid_attributes) do
      { employee: { name: "Jack Jones", email: "jackjones@example.com", department_id: department.id } }
    end

    let(:invalid_attributes) do
      { employee: { name: "", email: "invalid-email", department_id: nil } }
    end

    it "creates a new employee with valid attributes" do
      expect {
        post "/employees", params: valid_attributes
      }.to change(Employee, :count).by(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq("Jack Jones")
      expect(json_response["department"]["name"]).to eq("HR")
    end

    it "does not create a employee with invalid attributes" do
      post "/employees", params: invalid_attributes

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response).to include("name", "email", "department_id")
      expect(json_response["name"]).to include("can't be blank")
      expect(json_response["email"]).to include("is invalid")
      expect(json_response["department_id"]).to include("can't be blank")
    end
  end

  describe "PATCH/PUT /employees/:id" do
    let(:valid_update) { { employee: { name: "Updated Name" } } }

    it "updates the requested existing employee" do
      put "/employees/#{employee.id}", params: valid_update

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq("Updated Name")
    end

    it "returns and error in an invalid update" do
      invalid_update = { employee: { name: "" } }
      put "/employees/#{employee.id}", params: invalid_update

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response).to include("name")
    end
  end

  describe "DELETE /employees/:id" do
    it "deletes the requested employee" do
      expect {
        delete "/employees/#{employee.id}"
      }.to change(Employee, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns error in a 404 invalid update" do
      delete "/employees/900000"
      expect(response).to have_http_status(:not_found)
    end
  end
end
