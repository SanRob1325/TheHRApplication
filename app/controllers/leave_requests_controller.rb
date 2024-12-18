class LeaveRequestsController < ApplicationController
  before_action :set_leave_request, only: %i[update destroy]

  # Rescue from ActiveRecord::RecordNotFound for clearer error handling
  # This also renders a JSON error message if a record is not found Reference:https://medium.com/@wyou130/rescuing-from-activerecord-exceptions-in-ruby-on-rails-a21a4ed6e69b
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "LeaveRequest not found" }, status: :not_found
  end

  # GET /leave_requests
  def index
    @leave_requests = LeaveRequest.includes(:employee).all
    render json: @leave_requests.to_json(include: { employee: { only: [ :id, :name ] } })
  end

  # POST /leave_requests
  def create
    @leave_request = LeaveRequest.new(leave_request_params)
    @leave_request.status = "Pending"

    if @leave_request.save
      render json: @leave_request, status: :created
    else
      render json: @leave_request.errors, status: :unprocessable_entity
    end
  end

  # PUT /leave_requests/:id
  def update
    if @leave_request.update(leave_request_params)
      render json: @leave_request
    else
      render json: @leave_request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /leave_requests/:id
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
  # Callback to set a leave request based on the ID parameter
  def set_leave_request
    @leave_request = LeaveRequest.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "LeaveRequest not found" }, status: :not_found
  end
  # leaves request attributes in a whitelist
  def leave_request_params
    params.require(:leave_request).permit(:employee_id, :leave_type, :start_date, :end_date, :reason, :status)
  end
end
