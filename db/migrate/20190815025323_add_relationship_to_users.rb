class AddRelationshipToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :relationship, :string
  end
end
