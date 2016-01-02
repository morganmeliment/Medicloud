class UserUpdateOne < ActiveRecord::Migration
  def change
  	add_column :users, :notification_time, :string
  	add_column :users, :interaction_id, :string
  	add_column :users, :pill_container, :integer
  	add_column :users, :pills_left, :integer
  	add_column :users, :last_taken, :string
  	add_column :users, :auth_token, :string
  end
end
