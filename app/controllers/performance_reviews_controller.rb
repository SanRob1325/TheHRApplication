class PerformanceReviewsController < ApplicationController
  before_action :set_performance_review, only: [:update, :destroy]

  def index
    @performance_reviews = PerformanceReview.includes(:employee).all
    render json: @performance_reviews.to_json(include: {employee: {only: [:id, :name]}})
  end


  def create
    @performance_review = PerformanceReview.new(performance_review_params)

    if @performance_review.save
      render json: @performance_review, status: :created
    else
      render json: @performance_review.errors, status: :unprocessable_entity
    end
  end

  def update
    if @performance_review.update(performance_review_params)
      render json: @performance_review
    else
      render json: @performance_review.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @performance_review.destroy
  end

  private

  def set_performance_review
    @performance_review = PerformanceReview.find(params[:id])
  end

  def performance_review_params
    params.require(:performance_review).permit(:employee_id,:reviewer, :rating, :feedback)
  end
end
