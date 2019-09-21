class AddAdminCampus < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin_campus, :string
  end
end
