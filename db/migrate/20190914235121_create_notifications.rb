class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :title, null: false
      t.string :description
      t.datetime :publication_date, null: false, default: Time.now
      t.string :role
      t.string :relationship
      t.string :campus
      t.string :grade
      t.string :group
      t.string :family_key
      t.string :student_name
      t.boolean :seen, default: false
      t.string :category
      t.boolean :assist, default: false
      t.integer :event_id

      t.timestamps
    end
  end
end
