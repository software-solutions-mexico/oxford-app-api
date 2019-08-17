class AddLastNamesToKids < ActiveRecord::Migration[5.2]
  def change
    add_column :kids, :father_last_name, :string
    add_column :kids, :mother_last_name, :string
    add_column :kids, :student_id, :string
  end
end
