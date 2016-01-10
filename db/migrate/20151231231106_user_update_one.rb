class UserUpdateOne < ActiveRecord::Migration
  def change
  	add_column :medications, :notification_time, :string
  	add_column :medications, :interaction_id, :string
  	add_column :medications, :pill_container, :integer
  	add_column :medications, :pills_left, :integer
  	add_column :medications, :last_taken, :string
  	add_column :medications, :auth_token, :string
  	add_column :users, :deviceids, :string, array: true, default: []
  end
end
