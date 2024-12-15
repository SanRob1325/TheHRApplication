require "test_helper"

class AttendancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attendance = attendances(:one)
  end

  test "should get index" do
    get attendances_url, as: :json
    assert_response :success
  end

  test "should create attendance_spec.rb" do
    assert_difference("Attendance.count") do
      post attendances_url, params: { attendance: { date: @attendance.date, employee_id: @attendance.employee_id, status: @attendance.status } }, as: :json
    end

    assert_response :created
  end

  test "should show attendance_spec.rb" do
    get attendance_url(@attendance), as: :json
    assert_response :success
  end

  test "should update attendance_spec.rb" do
    patch attendance_url(@attendance), params: { attendance: { date: @attendance.date, employee_id: @attendance.employee_id, status: @attendance.status } }, as: :json
    assert_response :success
  end

  test "should destroy attendance_spec.rb" do
    assert_difference("Attendance.count", -1) do
      delete attendance_url(@attendance), as: :json
    end

    assert_response :no_content
  end
end
