require 'rails_helper'
#Test suite
RSpec.describe "PerformanceReviews", type: :request do
  let!(:department) { Department.create(name: "HR") }
  let!(:employee) { Employee.create(name: "Alice", email: "alice@example.com", department: department) }
  let!(:performance_reviews) { create_list(:performance_review, 3, employee: employee) }

  let(:valid_attributes) do
    {
      performance_review: {
        employee_id: employee.id,
        reviewer: "Manager",
        rating: 5,
        feedback: "Excellent performance"
      }
    }
  end

  let(:invalid_attributes) do
    {
      performance_review: {
        employee_id: nil,
        reviewer: nil,
        rating: nil,
        feedback: nil
      }
    }
  end
  # Helps parse JSON responses Reference:https://ruby-doc.org/stdlib-3.0.1/libdoc/json/rdoc/JSON.html
  def json
    JSON.parse(response.body) rescue {}
  end

  describe "GET /performance_reviews" do
    it "returns a list of performance_reviews" do
      get "/performance_reviews"
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(3)
    end
  end

  describe "POST /performance_reviews" do
    context "with valid request parameters" do
      it "creates a new performance_review" do
        expect {
          post "/performance_reviews", params: valid_attributes
        }.to change(PerformanceReview, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "when the request is invalid" do
      it "does not create a performance_review" do
        post "/performance_reviews", params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["employee"]).to include("must exist")
        expect(json["reviewer"]).to include("can't be blank")
        expect(json["rating"]).to include("can't be blank")
      end
    end
  end

  describe "PUT /performance_reviews/:id" do
    context "when the record exists" do
      let(:update_attributes) do
        {
          performance_review: {
            reviewer: "Manager",
            rating: 5,
            feedback: "Excellent performance"
          }
        }
      end

      it "updates the record" do
        review = performance_reviews.first
        put "/performance_reviews/#{review.id}", params: update_attributes
        expect(response).to have_http_status(:ok)
        expect(json["reviewer"]).to eq("Manager")
        expect(json["rating"]).to eq(5)
      end
    end

    context "when the record does not exist" do
      it "returns a not found error" do
        put "/performance_reviews/9999", params: valid_attributes
        expect(response).to have_http_status(:not_found)
        expect(json["error"]).to eq("Performance review not found")
      end
    end
  end

  describe "DELETE /performance_reviews/:id" do
    it "deletes the requested performance_review" do
      review = performance_reviews.first
      expect {
        delete "/performance_reviews/#{review.id}"
      }.to change(PerformanceReview, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    context "when the record is not found" do
      it "returns a not found error" do
        delete "/performance_reviews/9999"
        expect(response).to have_http_status(:not_found)
        expect(json["error"]).to eq("Performance review not found")
      end
    end
  end
end
