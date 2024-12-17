class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show update destroy ]

  # GET /employees
  def index
    @employees = Employee.includes(:department).all

    render json: @employees.to_json(include: :department)
  end

  # GET /employees/1
  def show
    render json: @employee.to_json(include: :department)
  end

  # POST /employees
  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      render json: @employee.to_json(include: :department), status: :created, location: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employees/1
  def update
    if @employee.update(employee_params)
      render json: @employee.to_json(include: :department)
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employees/1
  def destroy
    @employee.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(:name, :email, :department_id)
    end
end
