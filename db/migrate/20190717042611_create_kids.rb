class CreateKids < ActiveRecord::Migration[5.2]
  def change
    create_table :kids do |t|
      t.string :name
      t.string :grade
      t.string :group
      t.string :family_key

      t.timestamps
    end
  end
end
