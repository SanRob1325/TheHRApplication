class CreatePerformanceReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :performance_reviews do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :reviewer, null: false
      t.integer :rating, null: false
      t.text :feedback, null: false

      t.timestamps
    end
  end
end
