class LeaveRequestsController < ApplicationController
  before_action :set_leave_request, only: %i[update  destroy]

  def index
    @leave_requests = LeaveRequest.includes(:employee).all
    render json: @leave_requests.to_json(include: {employee: { only: [:id, :name] }})
  end

  def create
    @leave_request = LeaveRequest.new(leave_request_params)
    @leave_request.status = "Pending"

    if @leave_request.save
      render json: @leave_request, status: :created
    else
      render json: @leave_request.errors, status: :unprocessable_entity
    end
  end

  def update
    if @leave_request.update(leave_request_params)
      render json: @leave_request
    else
      render json: @leave_request.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @leave_request.destroy
  end

  def change_status
    if @leave_request.update(status: params[:status])
      render json: @leave_request, status: :ok
    else
      render json: @leave_request.errors, status: :unprocessable_entity
    end
  end

  private

  def set_leave_request
    @leave_request = LeaveRequest.find(params[:id])
  end

  def leave_request_params
    params.require(:leave_request).permit(:employee_id, :leave_type, :start_date, :end_date, :reason, :status)
  end
end
