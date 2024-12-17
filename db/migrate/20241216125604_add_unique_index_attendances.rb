class AddUniqueIndexAttendances < ActiveRecord::Migration[8.0]
  def change
    add_index :attendances, [ :employee_id, :date ], unique: true, name: 'index_attendances_on_employee_id_and_date'
  end
end
