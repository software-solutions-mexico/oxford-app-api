class AddCampusToKids < ActiveRecord::Migration[5.2]
  def change
    add_column :kids, :campus, :string
  end
end
