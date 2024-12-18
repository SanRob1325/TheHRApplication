class PerformanceReviewsController < ApplicationController
  before_action :set_performance_review, only: [ :update, :destroy ]
  # Rescue from ActiveRecord::RecordNotFound for clearer error handling
  # This also renders a JSON error message if a record is not found Reference:https://medium.com/@wyou130/rescuing-from-activerecord-exceptions-in-ruby-on-rails-a21a4ed6e69b
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Performance review not found" }, status: :not_found
  end
  # GET performance_reviews
  def index
    @performance_reviews = PerformanceReview.includes(:employee).all
    render json: @performance_reviews.to_json(include: { employee: { only: [ :id, :name ] } })
  end
  # POST /performance_reviews
  def create
    @performance_review = PerformanceReview.new(performance_review_params)

    if @performance_review.save
      render json: @performance_review, status: :created
    else
      render json: @performance_review.errors, status: :unprocessable_entity
    end
  end

  # PUT /performance_reviews
  def update
    if @performance_review.update(performance_review_params)
      render json: @performance_review
    else
      render json: @performance_review.errors, status: :unprocessable_entity
    end
  end

  # Delete performance_reviews/:id
  def destroy
    @performance_review.destroy
  end

  private

  # Call to find performance reviews by the ID
  def set_performance_review
    @performance_review = PerformanceReview.find(params[:id])
  end

  # Parameters that lists attributes for a performance review
  def performance_review_params
    params.require(:performance_review).permit(:employee_id, :reviewer, :rating, :feedback)
  end
end
