class AddNameRoleAndFamilyKeyToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :role, :string
    add_column :users, :family_key, :string
  end
end
