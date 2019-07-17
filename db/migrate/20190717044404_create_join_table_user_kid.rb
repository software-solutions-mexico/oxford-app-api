class CreateJoinTableUserKid < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :kids do |t|
      t.index [:user_id, :kid_id]
    end
  end
end
