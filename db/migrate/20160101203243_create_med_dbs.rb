class CreateMedDbs < ActiveRecord::Migration
  def change
    create_table :med_dbs do |t|
    	t.string :name
    end
  end
end
