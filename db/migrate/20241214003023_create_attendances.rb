class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.integer :employee_id
      t.date :date
      t.string :status

      t.timestamps
    end
  end
end
