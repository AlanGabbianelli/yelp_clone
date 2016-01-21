class AddUserIdToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :user_id, :serial
  end
end
