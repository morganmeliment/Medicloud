class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :selfid
      t.integer :accounts
      
      t.timestamps null: false
    end
  end
end
