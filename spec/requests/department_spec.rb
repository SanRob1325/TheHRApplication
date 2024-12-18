require 'rails_helper'
# Test library
RSpec.describe 'Departments API', type: :request do
  # creates a list of departments and valid attibutes associated with specific departments
  let!(:departments) { create_list(:department, 3) }
  let(:department_id) { departments.first.id }
  let(:valid_attributes) { { name: "Finance", description: "Finance" } }



  describe 'GET /departments' do
    it 'returns all departments' do
      get "/departments"
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(3)
    end

    describe "GET /departments/:id" do
      it "returns a single department" do
        get "/departments/#{department_id}"

        expect(response).to have_http_status(:ok)
        expect(json["id"]).to eq(department_id)
        expect(json["name"]).to eq(departments.first.name)
      end

      it "returns status code 404 when department doesn't exist" do
        get "/departments/99999"

        expect(response).to have_http_status(:not_found)
      end
    end

    describe "POST /departments" do
      let(:valid_attributes) { { name: "Finance", description: "Finance" } }

      context "when the request is valid" do
        it "creates a new department" do
          expect {
            post "/departments", params: { department: valid_attributes }
          }.to change(Department, :count).by(1)

          expect(response).to have_http_status(:created)
          expect(json["name"]).to eq("Finance")
        end
      end

      context "when the request is invalid" do
        it "does not create a new department without a name" do
          expect {
            post "/departments", params: { department: { description: "No name provided" } }
          }.to_not change(Department, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["name"]).to include("can't be blank")
        end
      end
    end

    describe "PUT /departments/:id" do
      let(:valid_attributes) { { name:  "Updated Name" } }

      context "when the department exists" do
        it "updates the department" do
          put "/departments/#{department_id}", params: { department: valid_attributes }

          updated_department = Department.find(department_id)
          expect(response).to have_http_status(:ok)
          expect(updated_department.name).to eq("Updated Name")
        end
      end

      context "when the department doesn't exist" do
        it "returns status code 404 when department doesn't exist" do
          put "/departments/99999", params: { department: valid_attributes }

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "DELETE /departments/:id" do
      context "when the department exists" do
        it "deletes the requested department" do
          expect {
            delete "/departments/#{department_id}"
          }.to change(Department, :count).by(-1)

          expect(response).to have_http_status(:no_content)
        end
      end

      context "when the department doesn't exist" do
        it "returns status code 404 when department doesn't exist" do
          delete "/departments/99999"
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    private

    def json
      JSON.parse(response.body)
    end
  end
end
