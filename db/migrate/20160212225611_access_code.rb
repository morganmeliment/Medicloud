class AccessCode < ActiveRecord::Migration
  def change
  	add_column :users, :accesscode, :string
  end
end
