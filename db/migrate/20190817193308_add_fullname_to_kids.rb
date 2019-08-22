class AddFullnameToKids < ActiveRecord::Migration[5.2]
  def change
    add_column :kids, :full_name, :string
  end
end
