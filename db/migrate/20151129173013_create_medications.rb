class CreateMedications < ActiveRecord::Migration
  def change
    create_table :medications do |t|
    	t.string :userid
    	t.string :name
    	t.string :schedule
    	t.string :dose
    	t.string :datapoints, array: true, default: []
      t.timestamps null: false
    end
  end
end
