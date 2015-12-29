class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :encryptedpassw
      t.boolean :active
      t.string :organization
      t.string :role
      t.string :fullname
      
      t.timestamps null: false
    end
  end
end
