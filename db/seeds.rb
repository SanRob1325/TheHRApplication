hr = Department.create(name: "Human Resources", description: "HR Department")
eng = Department.create(name: "Engineering", description: "Engineering Department")

Employee.create(name: "Alice", email: "alice@alice.com", department: hr)
Employee.create(name: "Bob", email: "bob@bob.com", department: eng)

Attendance.create(employee_id: 1, date: Date.today, status: "Present")
Attendance.create(employee_id: 2, date: Date.today, status: "Absent")

User.create!(
  email: "admin@admin.com",
  password: "password123",
  password_confirmation: "password123",
)