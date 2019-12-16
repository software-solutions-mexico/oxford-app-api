class CreateCampus < ActiveRecord::Migration[5.2]
  def change
    create_table :campus do |t|
      t.string :name
      t.text :groups

      t.timestamps
    end
  end
end
