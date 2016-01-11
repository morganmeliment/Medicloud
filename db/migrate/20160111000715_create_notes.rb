class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
    	t.string :userid
    	t.string :name
    	t.string :notecontent
    	
      t.timestamps null: false
    end
  end
end
