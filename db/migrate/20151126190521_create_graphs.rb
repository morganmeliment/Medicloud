class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
    	t.string :medid
    	t.string :name
    	t.integer :user_id
    	t.string :firstdate
    	t.string :datapoints, array: true, default: []

      t.timestamps null: false
    end
  end
end
