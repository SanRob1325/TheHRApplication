class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[ show update destroy ]

  # GET /attendances
  def index
    @attendances = Attendance.includes(:employee).all

    render json: @attendances.to_json(include: {employee: {only: [:id,:name]}})
  end

  # GET /attendances/1
  def show
    render json: @attendance.to_json(include:{employee: {only: [:id,:name]}})
  end

  # POST /attendances
  def create
    @attendance = Attendance.new(attendance_params)

    if @attendance.save
      render json: @attendance, status: :created
    else
      render json: {errors: @attendance.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attendances/1
  def update
    if @attendance.update(attendance_params)
      render json: @attendance.to_json(include: {employee: {only: [:id,:name]}})
    else
      render json: @attendance.errors, status: :unprocessable_entity
    end
  end

  # DELETE /attendances/1
  def destroy
    @attendance.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {error: "Attendance not found"}, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def attendance_params
      params.require(:attendance).permit(:employee_id, :date, :status)
    end
end
